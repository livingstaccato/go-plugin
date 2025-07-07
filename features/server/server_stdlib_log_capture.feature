# Source: server_test.go - TestServer_testStdLogger
Feature: Server Interaction with Standard Library Logger

  Scenario: Messages logged via standard 'log' package are captured when output is redirected to hclog
    Given the standard library 'log' package output is redirected to an hclogger instance
    And the hclogger instance writes its JSON output to a "log_output_buffer"
    And a plugin server is started in test mode with gRPC plugins, test handshake, and a null direct logger
    And the server provides reattach configuration and a close signal
    When reattach configuration is received from the server
    And the message "[DEBUG] test log" is written using the standard library 'log.Println'
    And the test mode server's context is canceled
    And the server's close channel signals completion
    Then the "log_output_buffer" should contain the message "test log"
