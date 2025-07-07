# Source: server_test.go - TestUnixSocketDir
Feature: Server Unix Socket Directory Configuration (non-Windows)

  Scenario: Server in test mode uses the directory specified by EnvUnixSocketDir for its Unix socket
    Given the operating system is not Windows
    And a temporary directory "temp_socket_dir" is created
    And the environment variable "HC_PLUGIN_UNIX_SOCKET_DIR" (EnvUnixSocketDir) is set to "temp_socket_dir"
    And a plugin server is started in test mode with gRPC plugins, test handshake, and a null logger
    And the server provides reattach configuration via a channel
    When reattach configuration is received from the server within 2 seconds
    Then the reattach configuration should not be nil
    And the network address in the reattach configuration should be a Unix socket
    And the directory of the Unix socket address should be "temp_socket_dir"
    When the test mode server's context is canceled
    Then the server's close channel should signal completion
