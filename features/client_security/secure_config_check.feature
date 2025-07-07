# Source: client.go - SecureConfig struct and Check method
Feature: SecureConfig Checksum Verification Logic

  Background:
    Ensuring plugin binary integrity via checksums is vital for security, especially in cross-platform scenarios
    where binaries might be sourced differently.

  Scenario: SecureConfig Check succeeds for a matching checksum
    Given a file "plugin_executable" with known content
    And a SecureConfig instance with a SHA256 hash algorithm
    And the SecureConfig checksum is pre-calculated correctly for "plugin_executable" using SHA256
    When the SecureConfig's Check method is called with the path to "plugin_executable"
    Then the method should return true
    And no error should occur

  Scenario: SecureConfig Check fails for a non-matching checksum
    Given a file "plugin_executable" with known content
    And a SecureConfig instance with a SHA256 hash algorithm
    And the SecureConfig checksum is deliberately incorrect (e.g., "dummy_checksum_bytes")
    When the SecureConfig's Check method is called with the path to "plugin_executable"
    Then the method should return false
    And no error should occur (error is for issues during check, not mismatch itself)

  Scenario: SecureConfig Check fails if the executable file does not exist
    Given a SecureConfig instance with a valid checksum and SHA256 hash algorithm
    And a file path "non_existent_plugin_executable" that does not point to an existing file
    When the SecureConfig's Check method is called with "non_existent_plugin_executable"
    Then the method should return false
    And an error indicating file open failure should occur (e.g., os.PathError)

  Scenario: SecureConfig Check fails if no checksum is provided in SecureConfig
    Given a file "plugin_executable"
    And a SecureConfig instance with a SHA256 hash algorithm but an empty Checksum
    When the SecureConfig's Check method is called with the path to "plugin_executable"
    Then the method should return false
    And an "ErrSecureConfigNoChecksum" error should occur

  Scenario: SecureConfig Check fails if no hash algorithm is provided in SecureConfig
    Given a file "plugin_executable"
    And a SecureConfig instance with a valid checksum but a nil Hash implementation
    When the SecureConfig's Check method is called with the path to "plugin_executable"
    Then the method should return false
    And an "ErrSecureConfigNoHash" error should occur
