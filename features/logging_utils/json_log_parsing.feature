# Source: log_entry.go - parseJSON function
Feature: JSON Log Entry Parsing

  Background:
    The `parseJSON` function is used to interpret structured JSON logs from plugin stderr.
    Consistent parsing of standard fields and arbitrary key-value pairs is important for diagnostics.

  Scenario: parseJSON correctly extracts standard hclog fields and remaining key-value pairs
    Given a JSON log line: '{"@message":"Plugin started", "@level":"INFO", "@timestamp":"2023-10-27T10:00:00.123456Z", "plugin_id":"123", "version": "1.1"}'
    When `parseJSON` is called with this line
    Then a logEntry struct should be returned
    And the logEntry.Message should be "Plugin started"
    And the logEntry.Level should be "INFO"
    And the logEntry.Timestamp should correspond to "2023-10-27T10:00:00.123456Z"
    And the logEntry.KVPairs should contain:
      | Key       | Value   |
      | plugin_id | "123"   |
      | version   | "1.1"   |
    And no error should be returned

  Scenario: parseJSON handles JSON with only a message
    Given a JSON log line: '{"@message":"Simple message"}'
    When `parseJSON` is called with this line
    Then a logEntry struct should be returned
    And the logEntry.Message should be "Simple message"
    And logEntry.Level should be empty or a default value if applicable
    And logEntry.Timestamp should be a zero time or default
    And logEntry.KVPairs should be empty
    And no error should be returned

  Scenario: parseJSON handles JSON with non-string standard fields gracefully (or as per current behavior)
    Given a JSON log line: '{"@message":123, "@level":true, "@timestamp": "nota_timestamp"}'
    When `parseJSON` is called with this line
    Then if "@message" is not a string, Message field should be empty or handle type assertion failure
    And if "@level" is not a string, Level field should be empty or handle type assertion failure
    And if "@timestamp" is not a valid timestamp string, an error related to time parsing should be returned OR Timestamp is zero
    # This test clarifies how type mismatches for standard fields are handled. Current code uses type assertion.

  Scenario: parseJSON fails on invalid JSON
    Given an invalid JSON log line: '{"message": "unterminated string'
    When `parseJSON` is called with this line
    Then a nil logEntry should be returned
    And an error indicating JSON unmarshal failure should be returned

  Scenario: flattenKVPairs correctly converts KVPairs to a flat slice for hclog
    Given a logEntry.KVPairs slice:
      | Key       | Value         |
      | "service" | "auth"        |
      | "retries" | 3             |
      | "active"  | true          |
    When `flattenKVPairs` is called with this slice
    Then the result should be an []interface{} slice: ["service", "auth", "retries", 3, "active", true]
