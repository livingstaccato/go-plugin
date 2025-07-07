# Source: client_test.go - TestClient_grpcSyncStdio
Feature: Client gRPC Stdio Synchronization

  Scenario: Client correctly syncs stdout and stderr from a gRPC plugin (default Cmd runner)
    Given a helper process "test-grpc"
    And a plugin client configured for gRPC with the "test-grpc" process
    And the client is configured to synchronize stdout to a buffer "syncOut"
    And the client is configured to synchronize stderr to a buffer "syncErr"
    When the plugin client is started
    Then the negotiated protocol should be gRPC
    And the "test" plugin can be dispensed
    And the reattach configuration PID should be non-zero
    When the plugin's "PrintStdio" method is called with stdout "hello\\nworld!" and stderr "and some error\\n messages!"
    And a short time passes for synchronization
    Then the "syncOut" buffer should contain "hello\\nworld!"
    And the "syncErr" buffer should contain "and some error\\n messages!"

  Scenario: Client correctly syncs stdout and stderr from a gRPC plugin (using RunnerFunc)
    Given a helper process "test-grpc"
    And a plugin client configured for gRPC using a RunnerFunc for the "test-grpc" process
    And the client is configured to synchronize stdout to a buffer "syncOut"
    And the client is configured to synchronize stderr to a buffer "syncErr"
    When the plugin client is started
    Then the negotiated protocol should be gRPC
    And the "test" plugin can be dispensed
    And the reattach configuration PID should be zero
    When the plugin's "PrintStdio" method is called with stdout "hello\\nworld!" and stderr "and some error\\n messages!"
    And a short time passes for synchronization
    Then the "syncOut" buffer should contain "hello\\nworld!"
    And the "syncErr" buffer should contain "and some error\\n messages!"
