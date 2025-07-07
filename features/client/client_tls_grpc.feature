# Source: client_test.go - TestClient_TLS_grpc
Feature: Client TLS Communication (gRPC)

  Scenario: Client successfully communicates with a gRPC plugin server using TLS
    Given a helper process "test-grpc-tls" that expects TLS connections for gRPC
    And a valid TLS configuration is available (from helperTLSProvider)
    And a plugin client configured with the "test-grpc-tls" process, gRPC plugins, the TLS configuration, and allowing gRPC protocol
    When an RPC client is obtained
    And the "test" plugin is dispensed
    Then the dispensed plugin should be a valid "testInterface"
    And calling the "Double" method on the "test" plugin with input 21 should return 42
    When the plugin client is killed
    Then the client should report as exited
    And the client should not report as killed (i.e., exited gracefully)
