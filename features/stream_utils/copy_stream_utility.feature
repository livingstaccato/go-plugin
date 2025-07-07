# Source: stream.go - copyStream function
Feature: copyStream Utility Function

  Background:
    The `copyStream` utility is used to reliably transfer data between an io.Reader and an io.Writer,
    often for plugin stdio/stderr streams. Consistent behavior across different I/O types and platforms is important.

  Scenario: copyStream successfully copies all data from source to destination
    Given an io.Reader "source" containing "hello world data"
    And an io.Writer "destination" (e.g., a bytes.Buffer)
    When `copyStream("test_stream", destination, source)` is called
    Then all data from "source" should be written to "destination"
    And "destination" should contain "hello world data"
    And no error should be logged by `copyStream`

  Scenario: copyStream handles EOF from source correctly (no error logged)
    Given an io.Reader "source" that will provide some data and then an io.EOF
    And an io.Writer "destination"
    When `copyStream("eof_test", destination, source)` is called
    Then all data before EOF from "source" should be written to "destination"
    And no error related to EOF should be logged by `copyStream`

  Scenario: copyStream logs an error if io.Copy returns an error (other than EOF)
    Given an io.Reader "source"
    And an io.Writer "faulty_destination" that will return an error "write_error" during io.Copy
    When `copyStream("error_test", faulty_destination, source)` is called
    Then an error message "[ERR] plugin: stream copy 'error_test' error: write_error" should be logged
    # This assumes the "write_error" is not io.EOF.

  Scenario: copyStream panics if source reader is nil
    Given an io.Reader "source" is nil
    And an io.Writer "destination"
    When `copyStream("nil_src_test", destination, source)` is called
    Then the function should panic with a message "nil_src_test: src is nil"

  Scenario: copyStream panics if destination writer is nil
    Given an io.Reader "source" containing data
    And an io.Writer "destination" is nil
    When `copyStream("nil_dst_test", destination, source)` is called
    Then the function should panic with a message "nil_dst_test: dst is nil"
