# Source: internal/grpcmux/*
Feature: gRPC Connection Multiplexing (GRPCMuxer)

  Background:
    The GRPCMuxer (client and server implementations) enables multiple gRPC services/streams
    over a single underlying network connection using yamux. This is critical for the gRPC broker.
    Interactions involve establishing a yamux session, handling a "default" listener for control services,
    and dynamically creating "blocked" listeners for specific brokered stream IDs via a knock/ack mechanism.

  Scenario: GRPCClientMuxer initialization establishes yamux session
    Given a network address "host_addr:port" where a gRPC server is listening
    And a logger
    When `NewGRPCClientMuxer(logger, "host_addr:port")` is called
    Then it should successfully dial "host_addr:port" to establish a base net.Conn
    And a yamux.Client session should be established over this base connection
    And a GRPCClientMuxer instance should be returned, ready for use
    And no error should occur

  Scenario: GRPCClientMuxer Dial opens a new yamux stream
    Given an initialized GRPCClientMuxer "client_muxer" with an active yamux session
    When `client_muxer.Dial()` is called
    Then a new yamux stream should be opened on its session
    And the stream (net.Conn) should be returned
    And no error should occur

  Scenario: GRPCClientMuxer Listener creates and registers a blockedClientListener
    Given an initialized GRPCClientMuxer "client_muxer"
    And a stream ID 123 and a done channel "done_ch"
    When `client_muxer.Listener(123, done_ch)` is called
    Then a new `blockedClientListener` for stream ID 123 and "done_ch" should be created, associated with the client_muxer's yamux session
    And this listener should be registered internally in "client_muxer.acceptListeners" mapped to ID 123
    And the listener should be returned
    And no error should occur

  Scenario: blockedClientListener Accept blocks until unblocked or done
    Given a `blockedClientListener` "client_ln" created by GRPCClientMuxer, associated with its yamux session and a "done_ch"
    When `client_ln.Accept()` is called (in a goroutine)
    Then the Accept call should block
    When `client_ln.unblock()` (via GRPCClientMuxer.AcceptKnock) is called
    And the yamux session subsequently accepts a new stream "new_conn"
    Then the blocked `client_ln.Accept()` call should return "new_conn" and no error
    # Alternative: If done_ch is closed before unblock, Accept returns io.EOF

  Scenario: GRPCServerMuxer initialization and accepting initial connection
    Given a net.Listener "initial_listener" (e.g., TCP or Unix) and a logger
    When `NewGRPCServerMuxer(logger, initial_listener)` is called
    Then a GRPCServerMuxer "server_muxer" is returned
    And a goroutine `server_muxer.acceptSession(initial_listener)` is started
    And `acceptSession` should call `initial_listener.Accept()` to get a base net.Conn "base_conn"
    And a yamux.Server session should be established over "base_conn"
    And the main `server_muxer.session()` method should eventually return this yamux session without error (within timeout)

  Scenario: GRPCServerMuxer default Accept routes to primary gRPC services
    Given an initialized GRPCServerMuxer "server_muxer" with an active yamux session
    And no specific knock is pending via `server_muxer.AcceptKnock()`
    When `server_muxer.Accept()` (as a net.Listener) is called
    And the yamux session accepts a new stream "default_stream"
    Then "default_stream" should be returned by `server_muxer.Accept()`
    And this "default_stream" is intended for the main gRPC services (broker, controller, stdio)

  Scenario: GRPCServerMuxer Listener creates and registers a blockedServerListener
    Given an initialized GRPCServerMuxer "server_muxer" with an active yamux session
    And a stream ID 456 and a done channel "done_ch"
    When `server_muxer.Listener(456, done_ch)` is called
    Then a new `blockedServerListener` for stream ID 456 and "done_ch" should be created
    And its `acceptCh` should be registered internally in "server_muxer.acceptChannels" mapped to ID 456
    And the listener should be returned

  Scenario: GRPCServerMuxer AcceptKnock and subsequent Accept route stream to specific listener
    Given an initialized GRPCServerMuxer "server_muxer" with an active yamux session
    And a `blockedServerListener` "server_ln_456" has been created and registered for stream ID 456
    When `server_muxer.AcceptKnock(456)` is called
    Then stream ID 456 should be sent to `server_muxer.knockCh`
    When `server_muxer.Accept()` (as net.Listener) is called (in a goroutine)
    And the yamux session accepts a new stream "specific_stream_456"
    Then because a knock for 456 is pending, "specific_stream_456" should be sent to "server_ln_456.acceptCh"
    And the `server_ln_456.Accept()` call (if active) should receive "specific_stream_456"

  Scenario: blockedServerListener Accept blocks until connection is routed or done
    Given a `blockedServerListener` "server_ln" created by GRPCServerMuxer, with its `acceptCh` and a "done_ch"
    When `server_ln.Accept()` is called (in a goroutine)
    Then the Accept call should block
    When a connection "routed_conn" (and nil error) is sent to "server_ln.acceptCh" by the GRPCServerMuxer
    Then the blocked `server_ln.Accept()` call should return "routed_conn" and no error
    # Alternative: If done_ch is closed before a connection is routed, Accept returns io.EOF

  Scenario: GRPCClientMuxer Close closes the yamux session
    Given an initialized GRPCClientMuxer "client_muxer" with an active yamux session
    When `client_muxer.Close()` is called
    Then its yamux session's `Close()` method should be invoked

  Scenario: GRPCServerMuxer Close closes its yamux session
    Given an initialized GRPCServerMuxer "server_muxer" with an active yamux session
    When `server_muxer.Close()` is called
    Then its yamux session's `Close()` method should be invoked

  Scenario: GRPCServerMuxer session timeout
    Given a GRPCServerMuxer is created with an initial listener
    But the initial listener never accepts a connection (or acceptSession hangs)
    When `server_muxer.session()` is called (e.g. by Accept or Listener)
    Then after 5 seconds, it should return an error "timed out waiting for connection to be established"
