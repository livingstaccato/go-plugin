# Source: mux_broker.go
Feature: MuxBroker Operation for NetRPC Stream Multiplexing

  Background:
    The MuxBroker manages multiplexed NetRPC streams over a single yamux session.
    Its correct handling of stream negotiation, timeouts, and lifecycle is critical for reliable NetRPC plugin communication.

  Scenario: MuxBroker Dial and Accept successfully establish a new stream
    Given a MuxBroker "broker" initialized with an active yamux session
    And the broker's Run method is active on the server side
    When the client side calls `broker.Dial(streamId=10)`
    Then a new yamux stream should be opened
    And the value 10 (streamId) should be written to this stream in little endian format
    And on the server side, the broker's Run method should accept this new stream
    And read the streamId 10 from it
    And place the stream onto a pending channel for streamId=10
    When the server side calls `broker.Accept(streamId=10)`
    Then it should retrieve the stream from the pending channel
    And write back the value 10 (ack) to the stream in little endian format
    And the client side's Dial method should read this ack 10
    And Dial should return the established net.Conn
    And Accept should return the established net.Conn

  Scenario: MuxBroker Accept times out if no client dials the specific ID
    Given a MuxBroker "broker" with its Run method active on the server side
    When the server side calls `broker.Accept(streamId=20)`
    And no client calls `broker.Dial(streamId=20)` within 5 seconds
    Then `broker.Accept(streamId=20)` should return an error indicating "timeout waiting for accept"
    And the pending stream information for streamId=20 should be cleaned up

  Scenario: MuxBroker Dial fails if yamux session cannot open a new stream
    Given a MuxBroker "broker" whose yamux session `OpenStream` will return an error "session_err"
    When the client side calls `broker.Dial(streamId=30)`
    Then the call should fail with "session_err"

  Scenario: MuxBroker Dial fails if writing stream ID fails
    Given a MuxBroker "broker" with an active yamux session
    And the underlying stream will fail during `binary.Write` of the stream ID
    When the client side calls `broker.Dial(streamId=30)`
    Then the call should fail with an error from `binary.Write`
    And the opened yamux stream should be closed

  Scenario: MUXBroker Dial fails if reading ACK fails or ACK is incorrect
    Given a MuxBroker "broker" with an active yamux session, and server ready to Accept
    And the server's Accept will write an incorrect ACK (e.g., 99) instead of the dialed ID (e.g., 30)
    When the client side calls `broker.Dial(streamId=30)`
    Then the call should fail with an error indicating "bad ack"
    And the opened yamux stream should be closed
    (Similar scenario if `binary.Read` for ACK itself fails)

  Scenario: MuxBroker Run method handles yamux AcceptStream errors
    Given a MuxBroker "broker" whose Run method is active
    And its yamux session `AcceptStream` returns an error "accept_err" (not io.EOF)
    When this error occurs
    Then the broker's Run method should exit its loop (effectively stopping the broker for new streams)

  Scenario: MuxBroker timeoutWait correctly cleans up unaccepted streams
    Given a MuxBroker "broker" whose Run method is active
    And a stream for ID 40 is accepted by Run and placed in pending, but `broker.Accept(40)` is not called
    When 5 seconds elapse after the stream was made pending
    Then the `timeoutWait` goroutine for stream ID 40 should trigger
    And the pending stream entry for ID 40 should be removed from the broker's map
    And if a connection was buffered in the pending channel, it should be closed

  Scenario: MuxBroker AcceptAndServe successfully serves a plugin on a new stream
    Given a MuxBroker "broker" with its Run method active
    And a plugin server implementation "plugin_impl"
    And a client is ready to dial stream ID 50
    When `broker.AcceptAndServe(streamId=50, plugin_impl)` is called
    Then it should successfully establish a connection for stream ID 50 (via internal Dial/Accept dance)
    And an RPC server should be started to serve "plugin_impl" on this new connection under the name "Plugin"

  Scenario: MuxBroker Close closes the underlying yamux session
    Given a MuxBroker "broker" initialized with an active yamux session
    When `broker.Close()` is called
    Then the underlying yamux session's Close method should be invoked
    And the error from the session's Close method should be returned.
