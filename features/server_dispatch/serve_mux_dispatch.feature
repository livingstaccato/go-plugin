# Source: server_mux.go - ServeMux function
Feature: ServeMux Plugin Dispatching

  Background:
    ServeMux allows a single plugin executable to serve different plugin types based on a command-line argument.
    This dispatch mechanism must be robust to incorrect arguments and correctly delegate to the `Serve` function.

  Scenario: ServeMux successfully dispatches to the correct ServeConfig based on command-line argument
    Given a ServeMuxMap with the following configurations:
      | ArgumentKey | ServeConfig Details                               |
      | "typeA"     | ConfigA (e.g., for a NetRPC plugin)               |
      | "typeB"     | ConfigB (e.g., for a gRPC plugin)                 |
    And the plugin executable is invoked with the command-line argument "typeA"
    When `ServeMux` is called with the ServeMuxMap
    Then the `Serve` function should be called with ConfigA
    And the program should behave according to ConfigA's plugin serving logic

  Scenario: ServeMux exits with error if no command-line argument is provided
    Given a ServeMuxMap
    And the plugin executable is invoked with no command-line arguments (os.Args length is not 2)
    When `ServeMux` is called
    Then an error message "Invoked improperly..." should be printed to stderr
    And the program should exit with status code 1

  Scenario: ServeMux exits with error if too many command-line arguments are provided
    Given a ServeMuxMap
    And the plugin executable is invoked with command-line arguments "typeA" "extraArg" (os.Args length > 2)
    When `ServeMux` is called
    Then an error message "Invoked improperly..." should be printed to stderr
    And the program should exit with status code 1

  Scenario: ServeMux exits with error if the command-line argument does not match any key in ServeMuxMap
    Given a ServeMuxMap with configurations for "typeA" and "typeB"
    And the plugin executable is invoked with the command-line argument "unknownType"
    When `ServeMux` is called
    Then an error message "Unknown plugin: unknownType" should be printed to stderr
    And the program should exit with status code 1
