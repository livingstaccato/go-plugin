# Source: client_test.go - TestClient_legacyClient
Feature: Client Version Negotiation with Legacy Server Behavior

  Scenario: Client using versioned handshake fails to ping when server offers a different plugin name at the negotiated version
    Given a helper process "test-proto-upgraded-plugin" (offers "old" NetRPC plugin at v1, "test" gRPC plugin at v2)
    And a plugin client configured with this process and a version-negotiating handshake
    And the client's VersionedPlugins offers a NetRPC plugin named "test" at version 1
    When an RPC client is obtained
    Then the negotiated protocol version should be 1
    And a ping to the RPC client should fail
    # This implies the client negotiated version 1, requested plugin "test" (NetRPC),
    # but the server at version 1 only offers an "old" NetRPC plugin.
