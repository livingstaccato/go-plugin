# Source: client_test.go - TestClient_StderrJSON
Feature: Client Stderr JSON Log Processing

  Scenario: Client's logger processes JSON and non-JSON stderr output from plugin
    Given a helper process "stderr-json" that writes a mix of JSON arrays, raw numbers, and JSON objects to its stderr
    And a plugin client configured with this process
    And the client's stderr is redirected to a general buffer
    And the client uses a custom hclog logger redirecting its output to a "logOutput" buffer
    When the plugin client is started
    And the client is allowed to run until it exits
    Then the client should not report as killed (i.e., exited gracefully)
    And the "logOutput" buffer from the hclog logger should contain a line with the JSON list "[\"HELLO\"]"
    And the "logOutput" buffer should contain a line with the raw number "12345"
    And the "logOutput" buffer should contain a line with the JSON object "{\"a\":1}"
