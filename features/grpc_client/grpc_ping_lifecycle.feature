# Source: grpc_client_test.go - TestGRPC_Ping
Feature: gRPC Client Ping Lifecycle

  Scenario: Default gRPC client can ping a live server and fails after server stops
    Given a test gRPC connection is established (mode: default) with a "testGRPCInterfacePlugin" (client and server)
    When the gRPC client pings the server
    Then the ping should be successful
    When the gRPC client pings the server again
    Then the ping should be successful
    When the remote gRPC server is stopped
    And the gRPC client pings the server again
    Then the ping should fail

  Scenario: Multiplexed gRPC client can ping a live server and fails after server stops
    Given a test gRPC connection is established (mode: multiplexed) with a "testGRPCInterfacePlugin" (client and server)
    When the gRPC client pings the server
    Then the ping should be successful
    When the gRPC client pings the server again
    Then the ping should be successful
    When the remote gRPC server is stopped
    And the gRPC client pings the server again
    Then the ping should fail
