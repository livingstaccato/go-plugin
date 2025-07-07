# Source: client_test.go - TestClient
Feature: Basic Client Operations

  Scenario: Client starts, provides address, and exits cleanly upon killing
    Given a helper process "mock"
    And a plugin client configured with the "mock" process, test handshake, test plugins, and a tracking logger
    When the plugin client is started
    Then the client should provide a "tcp" network address
    And the client should provide address string ":1234"
    And no error should occur during startup

    When the plugin client is killed
    Then the client should report as exited
    And the client should report as killed (failed)
    And the tracking logger should have 2 error messages logged
