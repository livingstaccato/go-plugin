# Source: grpc_client_test.go - TestGRPC_App
Feature: gRPC Client Application Interaction

  Scenario: Default gRPC client dispenses plugin, calls methods, and performs bidirectional communication
    Given a test gRPC connection is established (mode: default) with a "testGRPCInterfacePlugin"
    When the client dispenses the "test" plugin
    Then the plugin should be a valid "testInterface"
    And calling the "Double" method on the plugin with input 21 should return 42
    And calling the "Bidirectional" method on the plugin should succeed

  Scenario: Multiplexed gRPC client dispenses plugin, calls methods, and performs bidirectional communication
    Given a test gRPC connection is established (mode: multiplexed) with a "testGRPCInterfacePlugin"
    When the client dispenses the "test" plugin
    Then the plugin should be a valid "testInterface"
    And calling the "Double" method on the plugin with input 21 should return 42
    And calling the "Bidirectional" method on the plugin should succeed
