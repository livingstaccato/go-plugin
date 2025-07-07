# Source: rpc_client_test.go - TestClient_App
Feature: RPC Client Application Interaction (NetRPC)

  Scenario: RPC client dispenses a plugin and calls its methods
    Given a test RPC connection is established with a "testInterfacePlugin"
    When the client dispenses the "test" plugin
    Then the plugin should be a valid "testInterface"
    And calling the "Double" method on the plugin with input 21 should return 42
