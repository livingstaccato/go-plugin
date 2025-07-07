# Source: client_test.go - TestClient_Stderr
Feature: Client Stderr Handling

  Scenario: Client captures stderr output from the plugin process
    Given a helper process "stderr" that writes "HELLO\\n" and "WORLD\\n" to its stderr
    And a plugin client configured with this process
    And the client's stderr is redirected to a buffer
    When the plugin client is started
    And the client is allowed to run until it exits
    Then the client should not report as killed (i.e., exited gracefully)
    And the captured stderr buffer should contain "HELLO\\n"
    And the captured stderr buffer should contain "WORLD\\n"
