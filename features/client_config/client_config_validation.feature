# Source: client.go - Start method
Feature: Client Configuration Validation

  Background:
    Correct client configuration is essential for predictable behavior across platforms.

  Scenario: Client Start fails if Cmd and Reattach are both set
    Given a ClientConfig where both Cmd and ReattachConfig are specified
    When a new Client is created and Start is called
    Then an error should occur indicating that only one of Cmd or Reattach can be set
    # This is covered by features/client/client_cmd_and_reattach.feature but reiterated here for client.go direct logic.

  Scenario: Client Start fails if Cmd and RunnerFunc are both set
    Given a ClientConfig where both Cmd and RunnerFunc are specified
    When a new Client is created and Start is called
    Then an error should occur indicating that exactly one of Cmd, Reattach, or RunnerFunc must be set

  Scenario: Client Start fails if Reattach and RunnerFunc are both set
    Given a ClientConfig where both ReattachConfig and RunnerFunc are specified
    When a new Client is created and Start is called
    Then an error should occur indicating that exactly one of Cmd, Reattach, or RunnerFunc must be set

  Scenario: Client Start fails if Cmd, Reattach, and RunnerFunc are all set
    Given a ClientConfig where Cmd, ReattachConfig, and RunnerFunc are all specified
    When a new Client is created and Start is called
    Then an error should occur indicating that exactly one of Cmd, Reattach, or RunnerFunc must be set

  Scenario: Client Start fails if none of Cmd, Reattach, or RunnerFunc are set
    Given a ClientConfig where none of Cmd, ReattachConfig, or RunnerFunc are specified
    When a new Client is created and Start is called
    Then an error should occur indicating that exactly one of Cmd, Reattach, or RunnerFunc must be set

  Scenario: Client Start fails if SecureConfig and Reattach are both set
    Given a ClientConfig where both SecureConfig and ReattachConfig are specified
    When a new Client is created and Start is called
    Then an error should occur indicating that only one of Reattach or SecureConfig can be set
    # This is covered by features/client/client_secure_config_and_reattach.feature but reiterated.

  Scenario: Client Start fails if GRPCBrokerMultiplex and Reattach are both set
    Given a ClientConfig where both GRPCBrokerMultiplex is true and ReattachConfig is specified
    When a new Client is created and Start is called
    Then an error should occur indicating that gRPC broker multiplexing is not supported with Reattach config
