# Source: client_test.go - TestClient_wrongVersion
Feature: Client Version Negotiation (gRPC)

  Scenario: Client fails to connect if attempting to use gRPC with a version the server does not offer for that plugin
    Given a helper process "test-proto-upgraded-plugin" that offers a "test" gRPC plugin at version 2
    And a plugin client configured with this process, a handshake for version 1, gRPC plugins (for "test"), and allowing gRPC protocol
    When the client attempts to dispense an RPC client instance
    Then an error should occur
    # This implies a mismatch where the client requests gRPC plugin "test" at version 1,
    # but the server only provides "test" gRPC plugin at version 2.
