# Source: client_test.go - TestClient_mtlsClient
Feature: Client mTLS Communication (gRPC, AutoMTLS)

  Scenario: Client successfully communicates with gRPC plugin using AutoMTLS and handles subsequent crash
    Given a helper process "test-mtls" (server expects mTLS, offers "test" gRPC plugin at version 2)
    And a plugin client configured with this process, AutoMTLS enabled, and a version-negotiating handshake
    And the client's VersionedPlugins offers a gRPC plugin named "test" at version 2
    And the client allows the gRPC protocol
    When the plugin client is started
    Then the negotiated protocol should be gRPC
    And an RPC client can be obtained
    And the negotiated protocol version should be 2
    And the "test" plugin can be dispensed
    And the dispensed plugin should be a valid "testInterface"
    And calling the "Double" method on the "test" plugin with input 3 should return 6

    When the underlying plugin runner process is killed (simulating a crash)
    Then the client's done context should be closed within 2 seconds
