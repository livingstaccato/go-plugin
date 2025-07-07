# Source: client_test.go - TestClient_Start_Timeout
Feature: Client Start Failure Scenarios

  Scenario: Client fails to start if plugin does not respond within the start timeout
    Given a helper process "start-timeout" that deliberately delays its startup
    And a plugin client configured with this process and a 50ms start timeout
    When the plugin client attempts to start
    Then an error should occur during client start
    # This implies the plugin failed to handshake before the timeout.
