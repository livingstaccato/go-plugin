# Source: client.go - NewClient function and ClientConfig struct
Feature: Client Configuration Defaults

  Background:
    For robust cross-platform behavior, default configurations of the plugin client must be well-defined.

  Scenario: Client uses default port range if not specified
    Given a minimal ClientConfig with only HandshakeConfig, Plugins, and a valid Cmd
    When a new Client is created with this configuration
    Then the client's internal configuration should reflect a MinPort of 10000
    And the client's internal configuration should reflect a MaxPort of 25000
    # This ensures predictable port usage if not overridden, important for firewall or restricted environments.

  Scenario: Client uses default start timeout if not specified
    Given a minimal ClientConfig with only HandshakeConfig, Plugins, and a valid Cmd
    When a new Client is created with this configuration
    Then the client's internal configuration should reflect a StartTimeout of 1 minute
    # Consistent timeout behavior is crucial across platforms.

  Scenario: Client uses io.Discard for Stderr if not specified
    Given a minimal ClientConfig with only HandshakeConfig, Plugins, and a valid Cmd
    When a new Client is created with this configuration
    Then the client's configured Stderr should effectively be io.Discard
    # Prevents plugins from unintentionally polluting host stderr by default.

  Scenario: Client uses io.Discard for SyncStdout and SyncStderr if not specified
    Given a minimal ClientConfig with only HandshakeConfig, Plugins, and a valid Cmd
    When a new Client is created with this configuration
    Then the client's configured SyncStdout should effectively be io.Discard
    And the client's configured SyncStderr should effectively be io.Discard
    # Ensures no unexpected synced I/O by default.

  Scenario: Client defaults to only NetRPC protocol if AllowedProtocols is nil
    Given a minimal ClientConfig with only HandshakeConfig, Plugins, and a valid Cmd
    And AllowedProtocols is not set (nil)
    When a new Client is created with this configuration
    Then the client's internal list of allowed protocols should contain only ProtocolNetRPC
    # Important for legacy compatibility and explicit opt-in to other protocols.

  Scenario: Client uses a default hclog.Logger if none is provided
    Given a minimal ClientConfig with only HandshakeConfig, Plugins, and a valid Cmd
    When a new Client is created with this configuration
    Then the client should have a non-nil hclog.Logger instance
    And this logger should be named "plugin" and output to hclog.DefaultOutput at Trace level
    # Ensures logging is available even without explicit configuration.

  Scenario: Client uses default PluginLogBufferSize if not specified
    Given a minimal ClientConfig with only HandshakeConfig, Plugins, and a valid Cmd
    When a new Client is created with this configuration
    Then the client's internal configuration should reflect a PluginLogBufferSize of 65536 (64KB)
    # Consistent log buffering behavior for stderr parsing.
