# Source: client_test.go - TestClient_TLS
Feature: Client TLS Communication (NetRPC)

  Scenario: Client fails to dispense plugin when server expects TLS but client provides no TLS config
    Given a helper process "test-interface-tls" that expects TLS connections
    And a plugin client configured with this process but no TLS configuration
    When an RPC client is obtained
    And an attempt is made to dispense the "test" plugin
    Then an error should occur during plugin dispensing
    And the plugin client is subsequently killed

  Scenario: Client successfully communicates with a NetRPC plugin server using TLS
    Given a helper process "test-interface-tls" that expects TLS connections
    And a valid TLS configuration is available (from helperTLSProvider)
    And a plugin client configured with the "test-interface-tls" process and the TLS configuration
    When an RPC client is obtained
    And the "test" plugin is dispensed
    Then the dispensed plugin should be a valid "testInterface"
    And calling the "Double" method on the "test" plugin with input 21 should return 42
    When the plugin client is killed
    Then the client should report as exited
    And the client should not report as killed (i.e., exited gracefully)
