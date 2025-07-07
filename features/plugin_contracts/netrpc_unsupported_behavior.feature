# Source: plugin.go - NetRPCUnsupportedPlugin struct
Feature: NetRPCUnsupportedPlugin Behavior

  Background:
    A plugin may explicitly choose not to support the NetRPC protocol.
    This is relevant for cross-platform porting to ensure consistent protocol negotiation.

  Scenario: NetRPCUnsupportedPlugin Server method signals non-support
    Given an instance of `NetRPCUnsupportedPlugin`
    When its `Server` method is called (e.g., during an attempt to serve it via NetRPC)
    Then it must return a nil server component
    And it must return an error
    And the error message should indicate that the "net/rpc plugin protocol not supported"
    # This ensures that if a host attempts to use this plugin via NetRPC, it receives a clear error.

  Scenario: NetRPCUnsupportedPlugin Client method signals non-support
    Given an instance of `NetRPCUnsupportedPlugin`
    When its `Client` method is called (e.g., during an attempt to create a NetRPC client for it)
    Then it must return a nil client component
    And it must return an error
    And the error message should indicate that the "net/rpc plugin protocol not supported"
    # This ensures that if a host attempts to create a NetRPC client for this plugin, it receives a clear error.
