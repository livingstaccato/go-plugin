# Source: plugin_test.go - var _ Plugin = new(NetRPCUnsupportedPlugin)
Feature: NetRPCUnsupportedPlugin Type Compliance

  Scenario: NetRPCUnsupportedPlugin can be used as a standard Plugin
    Given a variable of type Plugin
    When a new NetRPCUnsupportedPlugin is created
    Then the NetRPCUnsupportedPlugin instance should be assignable to the Plugin variable
    # This scenario reflects a compile-time check in Go.
    # In a BDD context, this means that functions expecting a `plugin.Plugin`
    # should be able to accept a `NetRPCUnsupportedPlugin`.
