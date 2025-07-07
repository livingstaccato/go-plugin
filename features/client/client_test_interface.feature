# Source: client_test.go - TestClient_testInterface
Feature: Client Interface Interaction (NetRPC)

  Scenario: Client successfully interacts with a plugin over NetRPC
    Given a helper process "test-interface"
    And a plugin client configured with the "test-interface" process, test handshake, and test plugins
    When an RPC client is obtained
    And the "test" plugin is dispensed from the RPC client
    Then the dispensed plugin should be a valid "testInterface"
    And calling the "Double" method on the "test" plugin with input 21 should return 42

    When the plugin client is killed
    Then the client should report as exited
    And the client should not report as killed (i.e., exited gracefully)
