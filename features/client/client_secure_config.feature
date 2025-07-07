# Source: client_test.go - TestClient_SecureConfig
Feature: Client Secure Configuration for Plugin Integrity

  Scenario: Client fails to connect if SecureConfig checksum does not match plugin executable
    Given a helper process "test-interface"
    And a SecureConfig with an incorrect checksum "31" (byte '1') and SHA256 hash algorithm
    And a plugin client configured with the "test-interface" process and this SecureConfig
    When the client attempts to dispense an RPC client instance
    Then an "ErrChecksumsDoNotMatch" error should occur
    And the plugin client is subsequently killed

  Scenario: Client connects successfully if SecureConfig checksum matches plugin executable
    Given the "test-interface" helper process (which is part of the current test executable)
    And a SecureConfig with the correct SHA256 checksum of the test executable and SHA256 hash algorithm
    And a plugin client configured with the "test-interface" process and this SecureConfig
    When the client attempts to dispense an RPC client instance
    Then no error should occur
    And the plugin client is subsequently killed
