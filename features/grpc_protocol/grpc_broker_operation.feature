# Source: grpc_broker.go
Feature: gRPC Broker Operation for Connection Brokering

  Background:
    The GRPCBroker facilitates establishing multiple gRPC services or data streams
    over a single plugin connection, either via multiplexing or by negotiating new listeners.
    Its correct operation is vital for complex plugin interactions across platforms.

  Scenario: GRPCBroker successfully brokers a new connection (non-multiplexed)
    Given a GRPCBroker "broker" initialized with a functioning streamer and no multiplexer
    And the streamer is ready to send/receive ConnInfo messages
    And `serverListener` can create a new listener (e.g., TCP on "127.0.0.1:PORT_A")
    When the server side calls `broker.Accept(serviceId=1)`
    Then the streamer should send a ConnInfo for serviceId=1 with network "tcp" and address "127.0.0.1:PORT_A"
    And a new net.Listener should be returned to the server side
    When the client side calls `broker.Dial(serviceId=1)`
    Then the streamer should have received the ConnInfo for serviceId=1
    And a new gRPC connection should be established to "127.0.0.1:PORT_A"
    And this connection should be returned to the client side

  Scenario: GRPCBroker successfully brokers a new connection (multiplexed)
    Given a GRPCBroker "broker" initialized with a functioning streamer and an enabled GRPCMuxer "muxer"
    And the streamer is ready to send/receive ConnInfo messages (for knock/ack)
    When the server side calls `broker.Accept(serviceId=1)`
    Then `muxer.Listener(serviceId=1)` should be called to get a multiplexed listener
    And a goroutine to listen for knocks for serviceId=1 should be started
    And this multiplexed listener should be returned to the server side
    When the client side calls `broker.Dial(serviceId=1)`
    Then a knock message for serviceId=1 should be sent via the streamer
    And an ACK message for serviceId=1 should be received via the streamer from the server's knock listener
    And `muxer.Dial()` should be called to get a multiplexed connection
    And this connection should be returned to the client side

  Scenario: GRPCBroker AcceptAndServe correctly sets up and serves a new gRPC service
    Given a GRPCBroker "broker"
    And `broker.Accept(serviceId=1)` will successfully return a net.Listener "new_listener"
    And a function `newTestGRPCServer` creates a basic grpc.Server
    When `broker.AcceptAndServe(serviceId=1, newTestGRPCServer)` is called
    Then "new_listener" should be used to serve the gRPC server created by `newTestGRPCServer`
    And if TLS is configured on the broker, it should be applied to the new gRPC server
    And the serving goroutine should terminate if the broker is closed (broker.doneCh) or the server itself stops.
    And "new_listener" should be closed upon termination.

  Scenario: GRPCBroker Dial times out if connection info is not received (non-multiplexed)
    Given a GRPCBroker "broker" (non-multiplexed)
    And its streamer will not provide ConnInfo for serviceId=1 within the timeout period
    When the client side calls `broker.Dial(serviceId=1)`
    Then the call should time out after approximately 5 seconds
    And an error indicating "timeout waiting for connection info" should be returned

  Scenario: GRPCBroker Dial (multiplexed) times out if knock ACK is not received
    Given a GRPCBroker "broker" (multiplexed)
    And its streamer will send the knock for serviceId=1 but not receive an ACK within the timeout
    When the client side calls `broker.Dial(serviceId=1)`
    Then the call should time out after approximately 5 seconds waiting for the knock ACK
    And an error indicating "timeout waiting for multiplexing knock handshake" should be returned

  Scenario: GRPCBroker Run processes incoming ConnInfo messages
    Given a GRPCBroker "broker" whose Run method is active
    And its streamer receives a ConnInfo message for serviceId=1 (not a knock)
    When the message is processed by Run
    Then the ConnInfo should be placed onto the pending client stream channel for serviceId=1
    And a timeoutWait goroutine should be started for this client stream

  Scenario: GRPCBroker Run processes incoming knock messages (for multiplexed server)
    Given a GRPCBroker "broker" (multiplexed) whose Run method is active
    And its streamer receives a ConnInfo message for serviceId=1 that is a knock (Knock=true, Ack=false)
    When the message is processed by Run
    Then the ConnInfo should be placed onto the pending server stream channel for serviceId=1 (for listenForKnocks)

  Scenario: GRPCBroker Close shuts down the broker
    Given an active GRPCBroker "broker" with a running streamer
    When `broker.Close()` is called
    Then the broker's streamer Close method should be called
    And the broker's internal doneCh should be closed (once)

  Scenario: gRPCBrokerServer (streamer) Send/Recv/Close operations
    Given a gRPCBrokerServer "broker_server" handling a StartStream gRPC call
    When `broker_server.Send(connInfo)` is called
    Then connInfo should be sent on the gRPC stream
    When a ConnInfo message arrives on the gRPC stream
    Then `broker_server.Recv()` should make it available
    When `broker_server.Close()` is called
    Then its internal quit channel should be closed, stopping Send/Recv operations
    And subsequent Send/Recv should return "broker closed" error

  Scenario: gRPCBrokerClientImpl (streamer) Send/Recv/Close operations
    Given a gRPCBrokerClientImpl "broker_client" that has successfully started its stream
    When `broker_client.Send(connInfo)` is called
    Then connInfo should be sent on the gRPC stream
    When a ConnInfo message arrives on the gRPC stream
    Then `broker_client.Recv()` should make it available
    When `broker_client.Close()` is called
    Then its internal quit channel should be closed, stopping Send/Recv operations
    And subsequent Send/Recv should return "broker closed" error
