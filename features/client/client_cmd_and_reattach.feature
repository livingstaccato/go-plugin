# Source: client_test.go - TestClient_cmdAndReattach
Feature: Client Configuration Validation

  Scenario: Client fails to start if both command and reattach configuration are provided
    Given a helper process "start-timeout"
    And a default reattach configuration
    And a plugin client is configured with both the "start-timeout" process and the reattach configuration
    When the plugin client attempts to start
    Then an error should occur during client start
    # This implies that providing both Cmd and Reattach is an invalid configuration.
