# Source: client_posix_test.go - TestClient_testInterfaceReattach
Feature: Client Reattach on POSIX systems

  Scenario: Successfully reattach to a daemonized plugin process
    Given a helper process "test-interface-daemon" is configured for daemonization
    And a plugin client is configured with the helper process, test handshake, and test plugins
    When the plugin client is started
    And reattach information is obtained from the client
    Then the reattach information should not be nil

    Given the original plugin client is running
    And its reattach information
    When a new plugin client is configured for reattachment using this information
    And the new plugin client is started
    Then the new client should start without errors
    And the new client should be alive
    And an RPC client can be obtained from the new client
    And the "test" plugin can be dispensed
    And calling the "Double" method on the "test" plugin with input 21 should return 42
    And reattach information obtained from the new client should not be nil
    And the new reattach information should be identical to the original reattach information

    When the new plugin client is killed
    Then the new client should report as exited
