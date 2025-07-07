# Source: server_unix_test.go - TestUnixSocketGroupPermissions
Feature: Server Unix Socket File Permissions (non-Windows)

  Background:
    Given the current user's group ID (GID) and group name are determined

  Scenario: Unix socket file has correct group ownership and permissions when group is specified by GID
    Given a UnixSocketConfig with the group set to the current user's GID (as a string)
    When a Unix domain socket listener is created using this configuration via "serverListener_unix"
    Then the listener creation should succeed
    And the Unix socket file path can be obtained from the listener's address
    And the socket file permissions should be 0o660
    And the socket file group ID should match the current user's GID
    And the listener is subsequently closed

  Scenario: Unix socket file has correct group ownership and permissions when group is specified by name
    Given a UnixSocketConfig with the group set to the current user's group name
    When a Unix domain socket listener is created using this configuration via "serverListener_unix"
    Then the listener creation should succeed
    And the Unix socket file path can be obtained from the listener's address
    And the socket file permissions should be 0o660
    And the socket file group ID should match the current user's GID
    And the listener is subsequently closed
