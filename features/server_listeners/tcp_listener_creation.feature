# Source: server.go - serverListener_tcp function
Feature: Server TCP Listener Creation Logic

  Background:
    Reliable TCP listener creation across a port range is important for plugin communication,
    especially when default ports might be in use or restricted on different platforms.

  Scenario: TCP listener successfully binds to an available port within the specified range
    Given the environment variable PLUGIN_MIN_PORT is "12000"
    And the environment variable PLUGIN_MAX_PORT is "12005"
    And port 12000 is initially in use
    And port 12001 is available
    When the server attempts to create a TCP listener using `serverListener_tcp`
    Then a TCP listener should be successfully created
    And the listener's address should be "127.0.0.1:12001"

  Scenario: TCP listener creation fails if no ports are available in the specified range
    Given the environment variable PLUGIN_MIN_PORT is "12010"
    And the environment variable PLUGIN_MAX_PORT is "12011"
    And port 12010 is in use
    And port 12011 is in use
    When the server attempts to create a TCP listener using `serverListener_tcp`
    Then listener creation should fail
    And an error indicating "couldn't bind plugin TCP listener" should be returned

  Scenario: TCP listener uses default port range if environment variables are not set
    Given environment variables PLUGIN_MIN_PORT and PLUGIN_MAX_PORT are not set
    And at least one port between 10000 and 25000 is available (e.g., 10000)
    When the server attempts to create a TCP listener using `serverListener_tcp`
    Then a TCP listener should be successfully created on an available port within the default range (10000-25000)
    # Note: Actual port depends on availability; test implies checking a port like 127.0.0.1:10000

  Scenario: TCP listener creation fails if PLUGIN_MIN_PORT is greater than PLUGIN_MAX_PORT
    Given the environment variable PLUGIN_MIN_PORT is "12050"
    And the environment variable PLUGIN_MAX_PORT is "12040"
    When the server attempts to create a TCP listener using `serverListener_tcp`
    Then listener creation should fail
    And an error indicating that MIN_PORT is greater than MAX_PORT should be returned

  Scenario Outline: TCP listener creation fails with invalid port environment variables
    Given the environment variable PLUGIN_MIN_PORT is "<MinPort>"
    And the environment variable PLUGIN_MAX_PORT is "<MaxPort>"
    When the server attempts to create a TCP listener using `serverListener_tcp`
    Then listener creation should fail
    And an error indicating issues parsing the port environment variable should be returned

    Examples:
      | MinPort    | MaxPort    |
      | "notanum"  | "12000"    |
      | "12000"    | "notanum"  |
      | "invalid"  | "invalid2" |
