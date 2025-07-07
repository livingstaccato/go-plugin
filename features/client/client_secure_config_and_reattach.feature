# Source: client_test.go - TestClient_secureConfigAndReattach
Feature: Client Configuration Validation

  Scenario: Client fails to start if both SecureConfig and Reattach configuration are provided
    Given an empty SecureConfig
    And an empty ReattachConfig
    And a plugin client is configured with both the SecureConfig and the ReattachConfig
    When the plugin client attempts to start
    Then an "ErrSecureConfigAndReattach" error should occur during client start
