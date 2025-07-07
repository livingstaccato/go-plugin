# Source: server.go - serverListener_unix function
Feature: Server Unix Domain Socket Listener Creation Logic (Non-Windows)

  Background:
    Unix domain sockets are preferred on non-Windows platforms. Their creation involves specific filesystem interactions.
    This assumes the Go runtime environment correctly handles basic Unix socket operations for the target platform.

  Scenario: Unix listener successfully created with default socket directory
    Given the operating system is non-Windows
    And the UnixSocketConfig has an empty socketDir (implying os.CreateTemp default base)
    And the UnixSocketConfig has no Group specified
    When the server attempts to create a Unix listener using `serverListener_unix`
    Then a temporary file should be created in the default temporary directory
    And this temporary file should be closed and removed
    And a Unix domain socket listener should be successfully created at the path of the removed temporary file
    And the listener should be wrapped in an `rmListener` to ensure socket file cleanup on close

  Scenario: Unix listener successfully created with specified socket directory
    Given the operating system is non-Windows
    And a writable temporary directory "custom_socket_dir" exists
    And the UnixSocketConfig specifies "custom_socket_dir" as socketDir
    And the UnixSocketConfig has no Group specified
    When the server attempts to create a Unix listener using `serverListener_unix` with this config
    Then a temporary file should be created inside "custom_socket_dir"
    And this temporary file should be closed and removed
    And a Unix domain socket listener should be successfully created at the path within "custom_socket_dir"
    And the listener should be wrapped in an `rmListener`

  Scenario: Unix listener creation fails if temporary file creation fails
    Given the operating system is non-Windows
    And the UnixSocketConfig specifies a non-writable or non-existent directory as socketDir
    When the server attempts to create a Unix listener using `serverListener_unix`
    Then listener creation should fail with an error related to temporary file creation

  Scenario: Unix listener creation fails if listening on socket path fails
    Given the operating system is non-Windows
    And a socket file already exists at the path chosen for the new Unix listener (e.g., due to a race or stale file)
    When the server attempts to create a Unix listener using `serverListener_unix`
    Then listener creation should fail with an error related to listening on the socket path (e.g., address already in use)

  Scenario: Unix listener creation involves group ownership and permissions if Group is specified
    Given the operating system is non-Windows
    And a UnixSocketConfig specifies a valid Group "testgroup" and socketDir
    When the server attempts to create a Unix listener using `serverListener_unix`
    Then the created Unix socket file (before being wrapped by rmListener) should have its group ownership set to "testgroup"
    And its permissions set to 0o660
    # This relies on the setGroupWritable function; detailed tests for setGroupWritable are separate.
    # This scenario ensures serverListener_unix calls setGroupWritable when appropriate.
