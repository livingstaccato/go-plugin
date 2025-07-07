# Source: client_test.go - TestClient_noStdoutScannerRace
Feature: Client Stdout Handling Robustness

  Scenario: Client handles stdout scanning without race conditions during shutdown
    Given a helper process "test-grpc"
    And a plugin client configured with the "test-grpc" process and gRPC protocol
    And the client uses a custom runner that introduces a delay in stdout reading
    And a tracking logger
    When a plugin instance is obtained from the client
    And the plugin client is killed gracefully
    Then the tracking logger should have 0 error messages logged
    # This implies that the delayed stdout reading did not cause a race condition
    # with the process termination and stdout closing.
