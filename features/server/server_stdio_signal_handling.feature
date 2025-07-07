# Source: server.go - Serve function
Feature: Server Stdio Redirection and Signal Handling

  Background:
    Proper stdio redirection and signal handling are important for well-behaved plugins,
    especially for diagnostics and graceful shutdown across platforms.

  Scenario: Server redirects its os.Stdout and os.Stderr to pipes (non-test mode)
    Given a plugin server is started via `Serve` in non-test mode
    And the server's internal `stdout_w` and `stderr_w` are os.Pipe write ends
    When the plugin server logic (after handshake) attempts to write "message to stdout" to os.Stdout
    And "message to stderr" to os.Stderr
    Then "message to stdout" should be written to the `stdout_w` pipe
    And "message to stderr" should be written to the `stderr_w` pipe
    # This ensures that plugin output intended for its original stdout/stderr
    # is captured for potential syncing to the client.

  Scenario: Server uses TeeReader for stdio in test mode if SyncStdio is false (default)
    Given a plugin server is started via `Serve` in test mode
    And ServeTestConfig.SyncStdio is false
    And the server's internal `stdout_r` and `stderr_r` are os.Pipe read ends
    When the plugin server logic prepares its stdio readers for the ServerProtocol
    Then `stdout_r` should be an io.TeeReader piping to the original os.Stdout
    And `stderr_r` should be an io.TeeReader piping to the original os.Stderr
    # This allows test logs to appear on console while also being available to the plugin framework.

  Scenario: Server fully redirects stdio in test mode if SyncStdio is true
    Given a plugin server is started via `Serve` in test mode
    And ServeTestConfig.SyncStdio is true
    And the server's internal `stdout_w` and `stderr_w` are os.Pipe write ends
    When the plugin server logic redirects os.Stdout and os.Stderr
    Then os.Stdout within the Serve function should become `stdout_w`
    And os.Stderr within the Serve function should become `stderr_w`
    And the original os.Stdout and os.Stderr should be restored upon exiting Serve

  Scenario: Server ignores os.Interrupt signals in non-test mode
    Given a plugin server is started via `Serve` in non-test mode
    When an os.Interrupt signal is sent to the plugin process
    Then the server should log that it received the signal but ignore it
    And the server should continue running
    # This is to prevent accidental termination by Ctrl-C if the plugin is run directly by a user.

  Scenario: Server does not install custom signal handler in test mode
    Given a plugin server is started via `Serve` in test mode
    When the server initializes its signal handling
    Then no custom os.Interrupt signal handler should be installed by the Serve function
    # This allows `go test` to be cancelled normally.

  Scenario: Server exits with code 1 on MagicCookie misconfiguration (non-test mode)
    Given a ServeConfig with an empty MagicCookieKey or MagicCookieValue
    And the plugin server is started via `Serve` in non-test mode
    When the server initializes
    Then an error message about misconfigured ServeConfig should be printed to os.Stderr
    And the server process should exit with status code 1.
