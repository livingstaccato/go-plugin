# Source: client_test.go - TestClientStart_badVersion
Feature: Client Start Failure Scenarios

  Scenario: Client fails to start if plugin reports a bad protocol version
    Given a helper process "bad-version" that reports an incompatible protocol version
    And a plugin client configured with the "bad-version" process and a 50ms start timeout
    When the plugin client attempts to start
    Then an error should occur during client start
