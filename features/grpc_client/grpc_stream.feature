# Source: grpc_client_test.go - TestGRPCC_Stream
Feature: gRPC Client Streaming Interaction

  Scenario: Default gRPC client correcly handles a streaming RPC
    Given a test gRPC connection is established (mode: default) with a "testGRPCInterfacePlugin"
    When the client dispenses the "test" plugin as a "testStreamer"
    Then calling the "Stream" method on the plugin with start 21 and stop 27 should return the sequence [21, 22, 23, 24, 25, 26]
    And no error should occur during the stream operation

  Scenario: Multiplexed gRPC client correcly handles a streaming RPC
    Given a test gRPC connection is established (mode: multiplexed) with a "testGRPCInterfacePlugin"
    When the client dispenses the "test" plugin as a "testStreamer"
    Then calling the "Stream" method on the plugin with start 21 and stop 27 should return the sequence [21, 22, 23, 24, 25, 26]
    And no error should occur during the stream operation
