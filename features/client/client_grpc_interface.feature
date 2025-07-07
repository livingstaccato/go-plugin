# Source: client_test.go - TestClient_grpc
Feature: Client gRPC Interface Interaction

  Scenario: Client successfully interacts with a plugin over gRPC
    Given a helper process "test-grpc"
    And a plugin client configured with the "test-grpc" process, test handshake, gRPC plugins, and allowing only gRPC protocol
    When the plugin client is started
    Then the negotiated protocol should be gRPC
    And an RPC client can be obtained
    And the "test" plugin is dispensed from the RPC client
    And the dispensed plugin should be a valid "testInterface"
    And calling the "Double" method on the "test" plugin with input 21 should return 42

    When the plugin client is killed
    Then the client should report as exited
    And the client should not report as killed (i.e., exited gracefully)
