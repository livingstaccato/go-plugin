# Source: internal/cmdrunner/addr_translator.go
Feature: Identity Address Translator

  Background:
    The `addrTranslator` in `internal/cmdrunner` provides an identity transformation for network addresses.
    This is used when the plugin and host are assumed to be in the same network context.
    Ensuring this identity transformation is correctly implemented is important for predictable default behavior.

  Scenario: PluginToHost returns original network and address
    Given an instance of the `addrTranslator`
    And a plugin network string "tcp"
    And a plugin address string "127.0.0.1:1234"
    When the `PluginToHost` method is called with "tcp" and "127.0.0.1:1234"
    Then the returned network string should be "tcp"
    And the returned address string should be "127.0.0.1:1234"
    And the returned error should be nil

  Scenario: HostToPlugin returns original network and address
    Given an instance of the `addrTranslator`
    And a host network string "unix"
    And a host address string "/tmp/plugin.sock"
    When the `HostToPlugin` method is called with "unix" and "/tmp/plugin.sock"
    Then the returned network string should be "unix"
    And the returned address string should be "/tmp/plugin.sock"
    And the returned error should be nil

  Scenario: PluginToHost handles different types of addresses
    Given an instance of the `addrTranslator`
    And a plugin network string "unix"
    And a plugin address string "/var/run/my.sock"
    When the `PluginToHost` method is called with "unix" and "/var/run/my.sock"
    Then the returned network string should be "unix"
    And the returned address string should be "/var/run/my.sock"
    And the returned error should be nil

  Scenario: HostToPlugin handles different types of addresses
    Given an instance of the `addrTranslator`
    And a host network string "tcp"
    And a host address string "192.168.1.100:8080"
    When the `HostToPlugin` method is called with "tcp" and "192.168.1.100:8080"
    Then the returned network string should be "tcp"
    And the returned address string should be "192.168.1.100:8080"
    And the returned error should be nil
