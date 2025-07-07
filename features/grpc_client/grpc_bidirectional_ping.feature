# Source: grpc_client_test.go - TestGRPCConn_BidirectionalPing
Feature: gRPC Connection Bidirectional Ping

  Scenario: A gRPC client can ping a PingPong server
    Given a test gRPC connection is established with a registered "PingPongServer"
    And a "PingPongClient" is created using this connection
    When the "PingPongClient" sends a Ping request
    Then the response message should be "pong"
    And no error should occur during the ping operation
