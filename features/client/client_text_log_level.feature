# Source: client_test.go - TestClient_textLogLevel
Feature: Client Text Log Level Processing

  Scenario: Client's logger processes and respects log levels from plugin's text stderr
    Given a helper process "level-warn-text" that writes a log line "[WARN] test line 98765\\n" to its stderr
    And a plugin client configured with this process
    And the client's stderr is redirected to a general buffer
    And the client uses a custom hclog logger set to WARN level, redirecting its output to a "logOutput" buffer
    When the plugin client is started
    And the client is allowed to run until it exits
    Then the client should not report as killed (i.e., exited gracefully)
    And the "logOutput" buffer from the hclog logger should contain the message "test line 98765"
    # This implies that the logger correctly parsed the "[WARN]" prefix and honored the log level.
