# Source: server.go - setGroupWritable function
Feature: Set Group Writable Utility (Non-Windows)

  Background:
    Correctly setting group ownership and permissions on files (like Unix sockets) is crucial for security and accessibility.
    This functionality relies on OS-level calls that can vary or fail based on user privileges and group existence.
    These tests assume the user running them has permissions to chown/chmod files they create, at least to groups they belong to.

  Scenario: setGroupWritable successfully changes group and permissions using GID
    Given the operating system is non-Windows
    And a file "test_file.sock" exists
    And a valid numeric GID "target_gid" (e.g., current user's GID) exists on the system
    When `setGroupWritable` is called for "test_file.sock" with group "target_gid" and mode 0o660
    Then the operation should succeed
    And the group ownership of "test_file.sock" should be "target_gid"
    And the permissions of "test_file.sock" should be 0o660

  Scenario: setGroupWritable successfully changes group and permissions using group name
    Given the operating system is non-Windows
    And a file "test_file.sock" exists
    And a valid group name "target_group_name" (e.g., current user's primary group name) exists on the system
    When `setGroupWritable` is called for "test_file.sock" with group "target_group_name" and mode 0o660
    Then the operation should succeed
    And the group ownership of "test_file.sock" should correspond to "target_group_name"
    And the permissions of "test_file.sock" should be 0o660

  Scenario: setGroupWritable fails if group string is an invalid GID and non-existent group name
    Given the operating system is non-Windows
    And a file "test_file.sock" exists
    And "invalid_group_string" is neither a valid numeric GID nor an existing group name
    When `setGroupWritable` is called for "test_file.sock" with group "invalid_group_string" and mode 0o660
    Then the operation should fail with an error indicating failure to find GID from the group string

  Scenario: setGroupWritable fails if os.Chown fails (e.g., insufficient permissions)
    Given the operating system is non-Windows
    And a file "test_file.sock" exists, owned by a different user/group where current user lacks chown permission
    And a valid GID "target_gid"
    When `setGroupWritable` is called for "test_file.sock" with group "target_gid" and mode 0o660
    Then the operation should fail with an error from os.Chown

  Scenario: setGroupWritable fails if os.Chmod fails (e.g., insufficient permissions after chown)
    Given the operating system is non-Windows
    And a file "test_file.sock" exists
    And a valid GID "target_gid" (current user has permission to chown to this GID)
    And the filesystem or file attributes prevent chmod after chown (less common, but possible)
    When `setGroupWritable` is called for "test_file.sock" with group "target_gid" and mode 0o660
    Then if os.Chown succeeds, but os.Chmod subsequently fails, the operation should fail with an error from os.Chmod

  Scenario: setGroupWritable handles numeric GID string correctly
    Given the operating system is non-Windows
    And a file "test_file.sock" exists
    And the current user's GID is "current_gid_str" (as string)
    When `setGroupWritable` is called for "test_file.sock" with group "current_gid_str" and mode 0o770
    Then the operation should succeed
    And the group ownership of "test_file.sock" should be "current_gid_str" (numeric)
    And the permissions of "test_file.sock" should be 0o770
