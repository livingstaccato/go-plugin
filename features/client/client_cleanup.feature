# Source: client_test.go - TestClient_testCleanup
Feature: Client Cleanup Process

  Scenario: Plugin performs cleanup actions when client is killed gracefully
    Given a temporary file path for a cleanup indicator
    And a helper process "cleanup" configured to write to the indicator file on cleanup
    And a plugin client configured with the "cleanup" process, test handshake, test plugins, and a tracking logger
    When a plugin instance is obtained from the client
    And the plugin client is killed gracefully
    Then the cleanup indicator file should exist
    And the tracking logger should have 0 error messages logged
