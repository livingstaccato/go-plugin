# Source: runner/runner.go
Feature: Plugin Runner Interface Contracts

  Background:
    The Runner, AttachedRunner, and AddrTranslator interfaces define contracts for how plugin
    processes are managed and how their addresses are interpreted. These contracts are key for
    supporting diverse plugin execution environments (local, containers, etc.) in a cross-platform manner.

  Scenario: Runner interface contract for starting a new plugin
    Given an implementation "myRunner" of the `Runner` interface
    When `myRunner.Start(ctx)` is called
    Then it must attempt to start the plugin process or environment
    And return nil on successful start, or an error if starting fails
    And `myRunner.Stdout()` must return a valid io.ReadCloser for reading the plugin's stdout (for handshake)
    And `myRunner.Stderr()` must return a valid io.ReadCloser for reading the plugin's stderr (for logs)
    And `myRunner.Name()` must return a human-friendly string name
    And `myRunner.ID()` must return a unique string identifier for the running instance
    And `myRunner.Wait(ctx)` must block until the plugin terminates and return any error from its termination
    And `myRunner.Kill(ctx)` must attempt to terminate the plugin and return any error from that attempt
    And `myRunner.Diagnose(ctx)` must return a string with diagnostic information

  Scenario: AttachedRunner interface contract for an already running plugin
    Given an implementation "myAttachedRunner" of the `AttachedRunner` interface, representing an existing plugin
    When `myAttachedRunner.ID()` is called
    Then it must return a unique string identifier for the running instance
    When `myAttachedRunner.Wait(ctx)` is called
    Then it must block until the plugin terminates and return any error from its termination
    When `myAttachedRunner.Kill(ctx)` is called
    Then it must attempt to terminate the plugin and return any error from that attempt

  Scenario: AddrTranslator interface contract for address translation
    Given an implementation "myTranslator" of the `AddrTranslator` interface
    And a plugin reports its listening address as network "plugin_net" and address "plugin_addr"
    When `myTranslator.PluginToHost("plugin_net", "plugin_addr")` is called
    Then it must return the corresponding network "host_net", address "host_addr" from the host's perspective, and an error if translation fails
    And the host needs to communicate an address (network "host_orig_net", address "host_orig_addr") to a plugin
    When `myTranslator.HostToPlugin("host_orig_net", "host_orig_addr")` is called
    Then it must return the corresponding network "plugin_dest_net", address "plugin_dest_addr" from the plugin's perspective, and an error if translation fails
    # This contract allows abstracting network differences, e.g., Docker port mapping or different Unix socket paths.

  Scenario: ReattachFunc type contract
    Given a `ReattachFunc` "myReattachFunc" designed to connect to a specific type of running plugin
    When "myReattachFunc()" is called
    Then it must attempt to find and validate the existing plugin instance
    And if successful, it must return an object that implements the `AttachedRunner` interface and a nil error
    And if it fails to reattach, it must return nil and a non-nil error explaining the failure
