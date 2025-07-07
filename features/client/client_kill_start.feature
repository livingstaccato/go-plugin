# Source: client_test.go - TestClient_killStart
Feature: Client Kill Interaction with Start

  Scenario: Client Kill after a failed start due to bad version
    Given a temporary directory for a "booted" file
    And a helper process "bad-version" configured to write to the "booted" file on start
    And a plugin client configured with the "bad-version" process and test handshake
    And the "booted" file does not exist
    When the plugin client attempts to start
    Then an error should occur during client start
    And the "booted" file should now exist
    And the "booted" file can be successfully removed

    When the plugin client is killed
    Then the client should report as exited
    And the client should report as killed (process failed)
    And the "booted" file should still not exist
