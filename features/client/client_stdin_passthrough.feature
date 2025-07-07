# Source: client_test.go - TestClient_Stdin
Feature: Client Stdin Handling

  Scenario: Client correctly passes its stdin to the plugin process
    Given a temporary file containing the string "hello"
    And the host's standard input is redirected to this temporary file
    And a helper process "stdin" that reads 5 bytes from its stdin and exits successfully if it reads "hello"
    And a plugin client configured with this "stdin" process
    When the plugin client is started
    And the client is allowed to run until it exits
    Then the helper process should have exited successfully
    And the host's standard input is restored
    # This implies that the client successfully forwarded its stdin (now the temp file) to the plugin.
