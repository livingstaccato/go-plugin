# Source: examples/basic/*
Feature: Basic NetRPC Plugin Example (Greeter)

  Background:
    This feature describes the behavior of the basic NetRPC greeter example.
    It ensures that a simple host-plugin setup using NetRPC works as expected,
    which is fundamental for cross-platform compatibility of this plugin type.
    The plugin executable (e.g., "plugin/basic") is assumed to be built and available.

  Scenario: Host application successfully launches and interacts with the basic NetRPC greeter plugin
    Given the "basic" example's plugin executable is available
    And the host application (examples/basic/main.go) is configured to run this plugin
      | Configuration Point    | Detail                                         |
      | HandshakeConfig        | Matches between host and plugin                |
      | PluginSet key          | "greeter"                                      |
      | Plugin implementation  | a `Greeter` plugin using NetRPC                |
      | Client Cmd             | points to the "basic" plugin executable        |
    When the host application is run
    Then the host should launch the plugin executable as a child process
    And the host and plugin should successfully complete the handshake
    And the host should dispense the "greeter" plugin successfully
    And the host should call the "Greet" method on the dispensed greeter plugin
    And the "Greet" method should return the string "Hello from an example NetRPC plugin!"
    And the host application should print this greeting to its stdout
    And the plugin client should be cleaned up, terminating the plugin process

  Scenario: Plugin executable (basic greeter) serves the GreeterNetRPC plugin
    Given the "basic" example's plugin executable (plugin/main.go referenced by examples/basic/plugin/greeter_impl.go) is run by the host
    And it receives the correct magic cookie environment variables
    When the plugin initializes via `plugin.Serve()`
    Then it should register a "greeter" plugin implementing the `Greeter` interface via NetRPC
    And it should print its connection information (address, protocol) to its stdout for the host
    And it should wait for RPC calls from the host
    When the host calls the "Greet" method via RPC
    Then the plugin's `GreeterNetRPC.Greet()` method should be executed
    And it should return "Hello from an example NetRPC plugin!"
    When the host signals shutdown (e.g., closes RPC connection or sends Quit)
    Then the plugin process should terminate cleanly

  Scenario: Shared interface consistency for basic greeter
    Given the shared `Greeter` interface defines a `Greet()` string method (in examples/basic/shared/greeter_interface.go)
    And the plugin implements this interface (`GreeterNetRPC` in examples/basic/plugin/greeter_impl.go)
    And the host application uses this interface to interact with the dispensed plugin
    When the host calls the `Greet()` method
    Then the types and return values must match the shared interface definition
    # This ensures that the RPC mechanism correctly marshals/unmarshals data according to the shared contract.
    # Consistent interface definition and usage are vital for any plugin system, especially across platforms.
