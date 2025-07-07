# Source: client_test.go - TestClient_versionedClient
Feature: Client Version Negotiation and Crash Handling (gRPC)

  Scenario: Client successfully negotiates version with a versioned plugin server and handles subsequent crash
    Given a helper process "test-versioned-plugins" (server offers "test" gRPC plugin at version 2 via VersionedPlugins)
    And a plugin client configured with this process, a version-negotiating handshake, and allowing gRPC
    And the client's VersionedPlugins offers a gRPC plugin named "test" at version 2
    When the plugin client is started
    Then the negotiated protocol should be gRPC
    And an RPC client can be obtained
    And the negotiated protocol version should be 2
    And the "test" plugin can be dispensed
    And the dispensed plugin should be a valid "testInterface"

    When the underlying plugin runner process is killed (simulating a crash)
    Then the client's done context should be closed within 2 seconds
