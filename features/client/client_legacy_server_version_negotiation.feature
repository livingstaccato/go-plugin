# Source: client_test.go - TestClient_legacyServer
Feature: Client Version Negotiation with Server Using Single Protocol Version

  Scenario: Client using versioned handshake fails to ping when server serves a single hardcoded (higher) protocol version
    Given a helper process "test-proto-upgraded-client" (server hardcoded to offer its gRPC plugin at version 2)
    And a plugin client configured with this process, a version-negotiating handshake, and allowing gRPC
    And the client's VersionedPlugins offers a gRPC plugin named "test" at version 2
    When an RPC client is obtained
    Then the negotiated protocol version should be 2
    And a ping to the RPC client should fail
    # This implies a failure despite apparent version and name match, possibly due to
    # the server not fully complying with the version negotiation handshake, as it's
    # hardcoded to a single version.
