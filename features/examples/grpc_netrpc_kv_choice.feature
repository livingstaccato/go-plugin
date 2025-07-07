# Source: examples/grpc/*
Feature: gRPC and NetRPC KV Plugin Example (Host Choice)

  Background:
    This feature describes the behavior of the KV store example that offers both gRPC and NetRPC plugin implementations.
    The host application can choose which plugin type to run. This tests the library's ability to manage
    different plugin protocol types for the same conceptual service.
    Plugin executables (e.g., "plugin-go-grpc", "plugin-go-netrpc") are assumed to be built.

  Scenario: Host application successfully uses the gRPC KV plugin
    Given the "grpc" example's gRPC plugin executable ("plugin-go-grpc") is available
    And the host application (examples/grpc/main.go) is configured to run the "grpc" plugin type
      | Configuration Point    | Detail                                         |
      | HandshakeConfig        | Matches between host and plugin                |
      | PluginSet key          | "kv"                                           |
      | Client Cmd             | points to the "plugin-go-grpc" executable      |
    When the host application is run with the "grpc" flag
    Then the host should launch the "plugin-go-grpc" executable
    And the host and plugin should successfully complete the handshake for gRPC
    And the host should dispense the "kv" plugin, obtaining a `KV` interface instance "kv_client_grpc"
    When the host calls `kv_client_grpc.Put("key_grpc", "value_grpc")`
    Then the operation should succeed
    When the host calls `kv_client_grpc.Get("key_grpc")`
    Then it should return "value_grpc" and no error
    And the plugin client should be cleaned up

  Scenario: Host application successfully uses the NetRPC KV plugin
    Given the "grpc" example's NetRPC plugin executable ("plugin-go-netrpc") is available
    And the host application (examples/grpc/main.go) is configured to run the "netrpc" plugin type
      | Configuration Point    | Detail                                           |
      | HandshakeConfig        | Matches between host and plugin                  |
      | PluginSet key          | "kv"                                             |
      | Client Cmd             | points to the "plugin-go-netrpc" executable    |
    When the host application is run with the "netrpc" flag
    Then the host should launch the "plugin-go-netrpc" executable
    And the host and plugin should successfully complete the handshake for NetRPC
    And the host should dispense the "kv" plugin, obtaining a `KV` interface instance "kv_client_netrpc"
    When the host calls `kv_client_netrpc.Put("key_netrpc", "value_netrpc")`
    Then the operation should succeed
    When the host calls `kv_client_netrpc.Get("key_netrpc")`
    Then it should return "value_netrpc" and no error
    And the plugin client should be cleaned up

  Scenario: gRPC KV plugin implementation (plugin-go-grpc)
    Given the "grpc" example's gRPC plugin is run by the host
    When it initializes via `plugin.Serve()` with its `KVGRPCPlugin`
    Then it should serve the `KV` interface over gRPC
    When host calls `Put` or `Get`
    Then the corresponding methods in `kvGRPCServer` should be executed

  Scenario: NetRPC KV plugin implementation (plugin-go-netrpc)
    Given the "grpc" example's NetRPC plugin is run by the host
    When it initializes via `plugin.Serve()` with its `KVNetRPCPlugin`
    Then it should serve the `KV` interface over NetRPC
    When host calls `Put` or `Get`
    Then the corresponding methods in `KVNetRPC` (server-side) should be executed

  Scenario: Shared interface and protobuf for KV example
    Given the shared `KV` interface (examples/grpc/shared/interface.go) defines `Get` and `Put`
    And protobuf definitions in `kv.proto` define the KV service for gRPC
    And the gRPC plugin implements the protobuf KV service
    And the NetRPC plugin implements the `KV` interface directly for NetRPC
    And the host uses the shared `KV` interface for both plugin types
    Then interactions for both gRPC and NetRPC plugins must conform to the `KV` interface contract
    And gRPC interactions must conform to the protobuf service definition
    # Ensures that regardless of the chosen protocol, the core application logic (Put/Get) behaves as defined by the shared interface.
