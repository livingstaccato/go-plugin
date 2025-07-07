# Source: client_test.go - TestClient_ping
Feature: Client Ping Functionality (NetRPC)

  Scenario: Client can ping a live plugin and fails to ping after client is killed
    Given a helper process "test-interface"
    And a plugin client configured with the "test-interface" process, test handshake, and test plugins
    When an RPC client is obtained
    Then a ping to the RPC client should be successful
    When the plugin client is killed
    Then a ping to the RPC client should fail
