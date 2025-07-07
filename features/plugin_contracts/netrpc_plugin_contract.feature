# Source: plugin.go - Plugin interface
Feature: NetRPC Plugin Contract

  Background:
    A cross-platform porting effort requires clear contracts for plugin implementations.

  Scenario: A valid NetRPC plugin must provide a server component
    Given a plugin implementation that conforms to the `Plugin` interface
    And it intends to support NetRPC
    When the plugin's `Server` method is called with a MuxBroker instance
    Then it must return a non-nil RPC server compatible struct
    And it must return a nil error
    # This ensures that the plugin can expose its services over NetRPC.
    # Platform differences in network setup or RPC internals should not prevent this contract from being met.

  Scenario: A valid NetRPC plugin must provide a client component
    Given a plugin implementation that conforms to the `Plugin` interface
    And it intends to support NetRPC
    When the plugin's `Client` method is called with a MuxBroker instance and an rpc.Client
    Then it must return a non-nil interface implementation for the plugin
    And it must return a nil error
    # This ensures that the host can obtain a client to interact with the plugin's NetRPC services.
    # Any platform-specific client setup should be handled transparently by the implementation.

  Scenario: A NetRPC plugin's Server method can signal an error
    Given a plugin implementation that conforms to the `Plugin` interface
    And it encounters an issue setting up its NetRPC server component
    When the plugin's `Server` method is called
    Then it may return a nil server component
    And it must return a non-nil error describing the issue
    # This allows plugins to gracefully report setup failures, which might be due to platform-specific constraints.

  Scenario: A NetRPC plugin's Client method can signal an error
    Given a plugin implementation that conforms to the `Plugin` interface
    And it encounters an issue setting up its NetRPC client component
    When the plugin's `Client` method is called
    Then it may return a nil client component
    And it must return a non-nil error describing the issue
    # This allows plugin clients to gracefully report setup failures.
