# Source: client_test.go - TestClient_grpc_servercrash
Feature: Client Behavior on gRPC Server Crash

  Scenario: Client detects and handles gRPC server process crash
    Given a helper process "test-grpc"
    And a plugin client configured with the "test-grpc" process, test handshake, gRPC plugins, and allowing only gRPC protocol
    When the plugin client is started
    Then the negotiated protocol should be gRPC
    And an RPC client can be obtained
    And the "test" plugin can be dispensed
    And the dispensed plugin should be a valid "testInterface"

    When the underlying plugin runner process is killed (simulating a crash)
    Then the client's done context should be closed within 2 seconds
