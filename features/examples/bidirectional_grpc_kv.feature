# Source: examples/bidirectional/*
Feature: Bidirectional gRPC Plugin Example (KV Store)

  Background:
    This feature describes the behavior of the bidirectional gRPC KV store example.
    It showcases advanced gRPC features like using the GRPCBroker for plugin-to-host communication.
    Ensuring this works across platforms is key for complex plugin interactions.
    The plugin executable (e.g., from "plugin-go-grpc") is assumed to be built and available.

  Scenario: Host application interacts with the bidirectional gRPC KV plugin
    Given the "bidirectional" example's gRPC plugin executable is available
    And the host application (examples/bidirectional/main.go) is configured to run this plugin
      | Configuration Point    | Detail                                                       |
      | HandshakeConfig        | Matches between host and plugin                              |
      | PluginSet key          | "kv_grpc"                                                    |
      | Plugin implementation  | a `KV` gRPC plugin                                           |
      | Client Cmd             | points to the "bidirectional" gRPC plugin executable         |
    When the host application is run
    Then the host should launch the plugin executable
    And the host and plugin should successfully complete the handshake for gRPC
    And the host should dispense the "kv_grpc" plugin successfully, obtaining a `KV` interface instance "kv_client"

    When the host calls `kv_client.Put("foo", "bar")`
    Then the operation should succeed
    When the host calls `kv_client.Get("foo")`
    Then it should return the value "bar" and no error

    When the host calls `kv_client.Complex("key_for_complex", "value_for_complex")`
    Then the plugin's `Complex` method should be invoked
    And during the `Complex` method execution:
      | Plugin Action                                                                  | Host Action                                                                |
      | Plugin gets a new broker ID (e.g., 1)                                          |                                                                            |
      | Plugin calls `broker.AcceptAndServe(1, HostServiceServer)` on the host side    | Host serves `HostServiceServer` on a brokered connection for ID 1          |
      | Plugin dials broker ID 1 to connect back to the host's `HostServiceServer`     | Host's `HostServiceServer.Get()` is called by plugin with "key_for_complex"|
      | Plugin receives "value_from_host_via_broker" from its call to host's Get()     | Host's Get() returns "value_from_host_via_broker"                          |
    And the plugin's `Complex` method should complete successfully
    And the host's call to `kv_client.Complex` should complete successfully
    And the host application should print a success message indicating the complex interaction worked
    And the plugin client should be cleaned up, terminating the plugin process

  Scenario: Bidirectional gRPC plugin serves KV and interacts with host via broker
    Given the "bidirectional" example's gRPC plugin is run by the host
    And it initializes via `plugin.Serve()` with its `KVGRPCPlugin`
    When the host calls the `Put` RPC method with key "k1" and value "v1"
    Then the plugin should store "k1" = "v1"
    When the host calls the `Get` RPC method with key "k1"
    Then the plugin should return "v1"
    When the host calls the `Complex` RPC method with key "complex_key" and value "complex_value"
    Then the plugin should use its GRPCBroker to request the host to serve a `HostService` on a new stream ID
    And the plugin should dial this new stream ID to connect to the host's `HostService`
    And the plugin should call `HostService.Get("complex_key")` on the brokered connection
    And if the host's `HostService.Get` returns "host_response", the plugin should process it
    And the `Complex` method should complete successfully

  Scenario: Shared interfaces and protobuf definitions for bidirectional KV
    Given the shared `KV` interface defines `Put`, `Get`, and `Complex` methods
    And protobuf definitions in `kv.proto` define the services and messages for KV and HostService
    And the plugin implements the `KV` service (`kvGRPCServer`)
    And the host implements the `HostService` (`hostServiceServer`) for brokered calls
    When interactions occur via gRPC (direct or brokered)
    Then all request and response types must match the protobuf definitions
    And method calls must adhere to the `KV` and `HostService` service contracts
    # This ensures type safety and correct data marshalling/unmarshalling as defined by protobuf,
    # which is inherently cross-platform.
