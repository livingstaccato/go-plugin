# Source: client_test.go - TestClient_logStderrParseJSON
Feature: Client's logStderr Method JSON Parsing and Buffering

  Scenario: The logStderr method correctly parses JSON logs and handles long lines
    Given a plugin client instance
    And its PluginLogBufferSize is 64
    And its Logger is a JSON hclog.Logger writing to "logOutputBuffer"
    And an input message containing:
      """
      {"@message": "this is a message", "@level": "info"}
      {"@message": "this is a large message that is more than 64 bytes long", "@level": "info"}
      """
    When the client's logStderr method is called with "test" as the command path and the input message
    Then the "logOutputBuffer" should contain 3 log entries:
      | @level | @message                                                              |
      | info   | this is a message                                                     |
      | debug  | {"@message": "this is a large message that is more than 64 bytes     |
      | debug  |  long", "@level": "info"}                                             |
    # This reflects that the first JSON log is parsed correctly, and the second,
    # overly long JSON log, is split into debug messages due to buffer limitations.
