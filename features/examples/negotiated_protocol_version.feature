# Source: examples/negotiated/*
Feature: Negotiated Protocol Version Example (Greeter V1/V2)

  Background:
    This feature describes an example where host and plugin negotiate a protocol version.
    The plugin offers two versions of a "greeter" service (V1 via NetRPC, V2 via gRPC with an extra method).
    The host is capable of using either but prefers V2.
    This tests the version negotiation mechanism and protocol fallback.
    The plugin executable (e.g., from "plugin-go") is assumed to be built.

  Scenario: Host and plugin negotiate to the preferred common version (gRPC V2)
    Given the "negotiated" example's plugin executable is available
    And the plugin is configured to serve "greeter" version 1 (NetRPC) and version 2 (gRPC, with "Hello" method)
    And the host application (examples/negotiated/main.go) is configured with:
      | Configuration Point    | Detail                                                                 |
      | VersionedPlugins (client) | Offers client for "greeter" V1 (NetRPC) and V2 (gRPC, with "Hello")    |
      | Client Cmd             | points to the "negotiated" plugin executable                           |
      | AllowedProtocols       | Includes NetRPC and gRPC                                               |
    When the host application is run
    Then the host should launch the plugin executable
    And the host and plugin should successfully negotiate to protocol version 2 (gRPC)
    And the host's `client.NegotiatedVersion()` should return 2
    And the host should dispense the "greeter" plugin (as GreeterV2)
    And the host should call the "Hello" method on the dispensed plugin
    And the "Hello" method should return "Hello from Greeter V2!"
    And the host should print this "Hello" message
    And the plugin client should be cleaned up

  Scenario: Host and plugin negotiate to a fallback version if preferred is unavailable (NetRPC V1)
    Given the "negotiated" example's plugin executable is available
    And the plugin is configured to serve "greeter" ONLY version 1 (NetRPC)
      # (Simulated by modifying the plugin's ServeConfig for this scenario)
    And the host application (examples/negotiated/main.go) is configured as in the previous scenario (preferring V2 but supporting V1)
    When the host application is run
    Then the host should launch the plugin executable
    And the host and plugin should successfully negotiate to protocol version 1 (NetRPC)
    And the host's `client.NegotiatedVersion()` should return 1
    And the host should dispense the "greeter" plugin (as GreeterV1)
    And the host should call the "Greet" method on the dispensed plugin
    And the "Greet" method should return "Hello from Greeter V1!"
    And the host should print this "Greet" message
    And the plugin client should be cleaned up

  Scenario: Negotiated plugin (plugin-go) serves multiple versions
    Given the "negotiated" example's plugin is run by the host
    And it initializes via `plugin.Serve()` with `VersionedPlugins` for "greeter":
      | Version | Protocol | Offered Methods |
      | 1       | NetRPC   | Greet           |
      | 2       | gRPC     | Greet, Hello    |
    When the host connects and negotiates version 2 (gRPC)
    And calls the `Hello` RPC method
    Then the plugin's `GreeterV2GRPCServer.Hello()` should be executed
    When the host connects and negotiates version 1 (NetRPC)
    And calls the `Greet` RPC method
    Then the plugin's `GreeterV1NetRPC.Greet()` should be executed

  # This scenario relies on the client and server handshake logic already detailed
  # in features/handshake/ and features/client/client_handshake_details.feature.
  # The focus here is the application-level outcome of that negotiation.
