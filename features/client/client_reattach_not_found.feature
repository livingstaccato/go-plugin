# Source: client_test.go - TestClient_reattachNotFound
Feature: Client Reattachment Failure Scenarios

  Scenario: Client fails to reattach if the specified process is not found
    Given a PID for a process that is not running
    And a network address that is not actively listening
    And a plugin client is configured for reattachment with the non-existent PID and inactive address
    When the plugin client attempts to start
    Then an error should occur during client start
    And the error should be "ErrProcessNotFound"
