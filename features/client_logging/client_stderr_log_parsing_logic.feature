# Source: client.go - logStderr method
Feature: Client Stderr Log Parsing Logic

  Background:
    Consistent parsing of plugin stderr across platforms is important for diagnostics.
    The client's `logStderr` method contains logic to interpret log lines.

  Scenario Outline: Parsing hclog JSON from stderr
    Given the client's `logStderr` method is processing a line from plugin stderr
    And the line is "<JsonLogLine>"
    When the line is parsed
    Then it should be recognized as a valid JSON log entry
    And the parsed level should be "<ExpectedLevel>"
    And the parsed message should be "<ExpectedMessage>"
    And key-value pairs like "<ExampleKey>"="<ExampleValue>" should be extracted

    Examples:
      | JsonLogLine                                                          | ExpectedLevel | ExpectedMessage      | ExampleKey | ExampleValue |
      | {"@message":"info message","@level":"info","@timestamp":"T","foo":"bar"} | info          | info message         | foo        | bar          |
      | {"@message":"debug msg","@level":"debug","@timestamp":"T","val":123}    | debug         | debug msg            | val        | 123          |
      | {"@message":"no level","@timestamp":"T"}                               | debug         | {"@message":"no level","@timestamp":"T"} |            |              | # Defaults to debug if no level, logs original line

  Scenario Outline: Inferring log level from text prefixes in stderr
    Given the client's `logStderr` method is processing a line from plugin stderr
    And the line is "<TextLogLine>"
    And the line is NOT valid JSON
    When the line is processed for logging
    Then the client's logger should log it at "<InferredLevel>" with the original message (or substring)

    Examples:
      | TextLogLine             | InferredLevel |
      | [TRACE] trace message   | TRACE         |
      | [DEBUG] debug message   | DEBUG         |
      | [INFO] info message     | INFO          |
      | [WARN] warning message  | WARN          |
      | [ERROR] error message   | ERROR         |
      | panic: something bad    | ERROR         | # Panics are logged as errors
      |  goroutine 1 [running]: | ERROR         | # Panic continuations also logged as errors if previous was panic
      | just a normal line      | DEBUG         | # Defaults to DEBUG

  Scenario: Handling of long lines and continuations in stderr
    Given the client's `logStderr` method is configured with a specific buffer size
    And a log line from plugin stderr exceeds this buffer size, causing it to be read as multiple segments
    When the segments are processed
    Then the first segment should be logged at DEBUG level (as it's incomplete)
    And subsequent continuation segments should also be logged at DEBUG level
    And once the full line is reassembled (conceptually), if it were JSON, it would be parsed as such.
    # This ensures that very long lines don't break parsing and are still captured, albeit potentially at a default level.

  Scenario: Direct passthrough of stderr to configured Stderr writer
    Given the client is configured with a custom io.Writer "stderr_capture_buffer" for ClientConfig.Stderr
    And the client's `logStderr` method is processing a line "raw output line" from plugin stderr
    When the line is processed
    Then "raw output line" should be written to "stderr_capture_buffer"
    And this happens regardless of JSON parsing or log level inference for the internal logger.
