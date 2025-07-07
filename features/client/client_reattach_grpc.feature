# Source: client_test.go - TestClient_reattachGRPC
Feature: Client Reattachment (gRPC)

  Scenario: Client can successfully reattach to a gRPC plugin
    Given a primary plugin client configured with helper process "test-grpc", gRPC plugins, and allowing gRPC protocol
    When the primary client is started and an RPC client is obtained
    And reattach information is obtained from the primary client
    And the primary client is no longer active

    Given the obtained reattach information
    When a new plugin client is configured for gRPC reattachment using this information, test handshake, and gRPC plugins
    And the new plugin client is started
    Then an RPC client can be obtained from the new client
    And the "test" plugin can be dispensed
    And calling the "Double" method on the "test" plugin with input 21 should return 42

    When the new plugin client is killed
    Then the new client should report as exited
    And the new client should not report as killed (i.e., exited gracefully)

  Scenario: Client can successfully reattach to a gRPC plugin using ReattachFunc
    Given a primary plugin client configured with helper process "test-grpc", gRPC plugins, and allowing gRPC protocol
    When the primary client is started and an RPC client is obtained
    And reattach information is obtained from the primary client
    And the reattach information is modified to use a ReattachFunc (PID set to 0, ReattachFunc populated)
    And the primary client is no longer active

    Given the modified reattach information (using ReattachFunc)
    When a new plugin client is configured for gRPC reattachment using this information, test handshake, and gRPC plugins
    And the new plugin client is started
    Then an RPC client can be obtained from the new client
    And the "test" plugin can be dispensed
    And calling the "Double" method on the "test" plugin with input 21 should return 42

    When the new plugin client is killed
    Then the new client should report as exited
    And the new client should not report as killed (i.e., exited gracefully)
