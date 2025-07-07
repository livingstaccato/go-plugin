# Source: client_test.go - TestClient_logStderr
Feature: Client's logStderr Method Functionality

  Scenario: The logStderr method correctly buffers and outputs diverse stderr messages
    Given a plugin client instance
    And its Stderr is configured to write to a buffer "stderrOutput"
    And its PluginLogBufferSize is 32
    And an input message containing:
      """
      \nthis line is more than 32 bytes long
      and this line is more than 32 bytes long
      {"a": "b", "@level": "debug"}
      this line is short\n
      """
    When the client's logStderr method is called with "test" as the command path and the input message
    Then the "stderrOutput" buffer should contain exactly the input message
