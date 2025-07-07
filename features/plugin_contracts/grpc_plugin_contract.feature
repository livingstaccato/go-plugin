# Source: plugin.go - GRPCPlugin interface
Feature: gRPC Plugin Contract

  Background:
    A cross-platform porting effort requires clear contracts for plugin implementations.

  Scenario: A valid gRPC plugin must register its server component
    Given a plugin implementation that conforms to the `GRPCPlugin` interface
    And it intends to support gRPC
    When the plugin's `GRPCServer` method is called with a GRPCBroker and a grpc.Server instance
    Then it must register its gRPC services with the provided grpc.Server
    And it must return a nil error
    # This ensures the plugin's gRPC services are exposed.
    # Platform-specific gRPC server setup details should be abstracted by the framework.

  Scenario: A valid gRPC plugin must provide a client component
    Given a plugin implementation that conforms to the `GRPCPlugin` interface
    And it intends to support gRPC
    When the plugin's `GRPCClient` method is called with a context, a GRPCBroker, and a grpc.ClientConn
    Then it must return a non-nil interface implementation for the plugin (gRPC client)
    And it must return a nil error
    # This ensures the host can obtain a client to interact with the plugin's gRPC services.
    # The provided context's cancellation due to plugin exit should be respected by the client.

  Scenario: A gRPC plugin's GRPCServer method can signal an error
    Given a plugin implementation that conforms to the `GRPCPlugin` interface
    And it encounters an issue registering its gRPC server component
    When the plugin's `GRPCServer` method is called
    Then it must return a non-nil error describing the issue
    # This allows plugins to gracefully report setup failures.

  Scenario: A gRPC plugin's GRPCClient method can signal an error
    Given a plugin implementation that conforms to the `GRPCPlugin` interface
    And it encounters an issue setting up its gRPC client component
    When the plugin's `GRPCClient` method is called
    Then it may return a nil client component
    And it must return a non-nil error describing the issue
    # This allows plugin clients to gracefully report setup failures.
