# Source: client_test.go - TestClient_logger
Feature: Client Handling of Plugin-Generated Logs

  Scenario: Plugin logs (string value) via NetRPC are captured by client's logger
    Given a helper process "test-interface-logger-netrpc"
    And a plugin client configured with this process and a custom client logger whose output is captured in "logBuffer"
    And the client allows NetRPC and gRPC protocols
    When an RPC client is obtained and the "test" plugin is dispensed
    And the plugin's "PrintKV" method is called with key "foo" and string value "bar"
    And a short time passes for logs to be processed
    Then the "logBuffer" should contain a log message with "foo=bar"
    And the plugin client is subsequently killed
    And the client should report as exited and not killed

  Scenario: Plugin logs (integer value) via NetRPC are captured by client's logger
    Given a helper process "test-interface-logger-netrpc"
    And a plugin client configured with this process and a custom client logger whose output is captured in "logBuffer"
    And the client allows NetRPC and gRPC protocols
    When an RPC client is obtained and the "test" plugin is dispensed
    And the plugin's "PrintKV" method is called with key "foo" and integer value 12
    And a short time passes for logs to be processed
    Then the "logBuffer" should contain a log message with "foo=12"
    And the plugin client is subsequently killed
    And the client should report as exited and not killed

  Scenario: Plugin logs (string value) via gRPC are captured by client's logger
    Given a helper process "test-interface-logger-grpc"
    And a plugin client configured with this process and a custom client logger whose output is captured in "logBuffer"
    And the client allows NetRPC and gRPC protocols
    When an RPC client is obtained and the "test" plugin is dispensed
    And the plugin's "PrintKV" method is called with key "foo" and string value "bar"
    And a short time passes for logs to be processed
    Then the "logBuffer" should contain a log message with "foo=bar"
    And the plugin client is subsequently killed
    And the client should report as exited and not killed

  Scenario: Plugin logs (integer value) via gRPC are captured by client's logger
    Given a helper process "test-interface-logger-grpc"
    And a plugin client configured with this process and a custom client logger whose output is captured in "logBuffer"
    And the client allows NetRPC and gRPC protocols
    When an RPC client is obtained and the "test" plugin is dispensed
    And the plugin's "PrintKV" method is called with key "foo" and integer value 12
    And a short time passes for logs to be processed
    Then the "logBuffer" should contain a log message with "foo=12"
    And the plugin client is subsequently killed
    And the client should report as exited and not killed
