# Source: client_test.go - TestClient_reattachNoProtocol
Feature: Client Reattachment (NetRPC) with Missing Protocol Information

  Scenario: Client can successfully reattach to a NetRPC plugin even if protocol is missing in reattach info
    Given a primary plugin client configured with helper process "test-interface", test handshake, and test plugins
    When the primary client is started and an RPC client is obtained
    And reattach information is obtained from the primary client
    And the protocol field in the obtained reattach information is cleared
    And the primary client is no longer active

    Given the modified reattach information (with no protocol)
    When a new plugin client is configured for reattachment using this information, test handshake, and test plugins
    And the new plugin client is started
    Then an RPC client can be obtained from the new client
    And the "test" plugin can be dispensed
    And calling the "Double" method on the "test" plugin with input 21 should return 42

    When the new plugin client is killed
    Then the new client should report as exited
    And the new client should not report as killed (i.e., exited gracefully)
