# Source: client_test.go - TestClient_mtlsNetRPCClient
Feature: Client mTLS Communication (NetRPC, AutoMTLS)

  Scenario: Client successfully communicates with NetRPC plugin using AutoMTLS and handles subsequent crash
    Given a helper process "test-interface-mtls" (server expects mTLS for NetRPC)
    And a plugin client configured with this process, AutoMTLS enabled, and a version-negotiating handshake
    And the client is configured with NetRPC plugins (testPluginMap for "test")
    And the client allows the NetRPC protocol
    When the plugin client is started
    And an RPC client can be obtained
    And the "test" plugin can be dispensed
    And the dispensed plugin should be a valid "testInterface"
    And calling the "Double" method on the "test" plugin with input 3 should return 6

    When the underlying plugin runner process is killed (simulating a crash)
    Then the client's done context should be closed within 2 seconds
