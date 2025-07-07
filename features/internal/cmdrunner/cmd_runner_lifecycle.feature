# Source: internal/cmdrunner/cmd_runner.go
Feature: CmdRunner Subprocess Management

  Background:
    CmdRunner is responsible for managing the lifecycle of a plugin subprocess using exec.Cmd.
    Its behavior needs to be consistent for starting, monitoring, and stopping plugins across platforms.

  Scenario: NewCmdRunner successfully prepares a command for execution
    Given an unstarted exec.Cmd "test_cmd" configured with a path to an executable
    And a logger instance
    When `NewCmdRunner(logger, test_cmd)` is called
    Then a CmdRunner instance "runner" should be returned
    And "runner.cmd" should be "test_cmd"
    And "runner.stdout" pipe should be successfully created from "test_cmd.StdoutPipe()"
    And "runner.stderr" pipe should be successfully created from "test_cmd.StderrPipe()"
    And "runner.path" should be cached from "test_cmd.Path"
    And no error should be returned

  Scenario: NewCmdRunner fails if stdout pipe creation fails
    Given an exec.Cmd "test_cmd" for which `StdoutPipe()` will return an error "stdout_pipe_error"
    When `NewCmdRunner(logger, test_cmd)` is called
    Then it should return nil
    And an error "stdout_pipe_error" should be returned

  Scenario: NewCmdRunner fails if stderr pipe creation fails
    Given an exec.Cmd "test_cmd" for which `StdoutPipe()` succeeds but `StderrPipe()` will return an error "stderr_pipe_error"
    When `NewCmdRunner(logger, test_cmd)` is called
    Then it should return nil
    And an error "stderr_pipe_error" should be returned

  Scenario: CmdRunner Start successfully starts the command
    Given a CmdRunner "runner" initialized with a valid, unstarted exec.Cmd "test_cmd"
    When `runner.Start(ctx)` is called
    Then `test_cmd.Start()` should be invoked successfully
    And `runner.pid` should be set to the PID of the started process
    And a debug log "plugin started" with path and PID should be made
    And no error should be returned by `runner.Start`

  Scenario: CmdRunner Start propagates errors from exec.Cmd.Start()
    Given a CmdRunner "runner" initialized with an exec.Cmd "test_cmd" whose `Start()` method will fail with "start_error"
    When `runner.Start(ctx)` is called
    Then it should return "start_error"

  Scenario: CmdRunner Wait successfully waits for command completion
    Given a CmdRunner "runner" for a started exec.Cmd "test_cmd" that will exit successfully
    When `runner.Wait(ctx)` is called
    Then `test_cmd.Wait()` should be invoked
    And no error should be returned by `runner.Wait` (assuming successful exit)

  Scenario: CmdRunner Kill successfully terminates the process
    Given a CmdRunner "runner" for a running exec.Cmd "test_cmd"
    When `runner.Kill(ctx)` is called
    Then `test_cmd.Process.Kill()` should be invoked
    And no error should be returned by `runner.Kill` (if kill is successful)

  Scenario: CmdRunner Kill is idempotent and handles os.ErrProcessDone
    Given a CmdRunner "runner" for a running exec.Cmd "test_cmd"
    When `runner.Kill(ctx)` is called, and the process terminates
    And `runner.Kill(ctx)` is called again
    Then the second call should not return an error (specifically, os.ErrProcessDone is swallowed)

  Scenario: CmdRunner Kill does nothing if process is not set
    Given a CmdRunner "runner" whose internal `cmd.Process` is nil (e.g., command not started or already fully waited on)
    When `runner.Kill(ctx)` is called
    Then no attempt to kill a process should be made
    And no error should be returned

  Scenario: CmdRunner accessors return correct information
    Given a CmdRunner "runner" initialized with exec.Cmd (path "/usr/bin/plug", PID 123) and its stdout/stderr pipes
    When `runner.Stdout()` is called, it returns the stdout pipe
    When `runner.Stderr()` is called, it returns the stderr pipe
    When `runner.Name()` is called, it returns "/usr/bin/plug"
    When `runner.ID()` is called, it returns "123"

  Scenario: CmdRunner Diagnose returns a formatted message including platform-specific notes
    Given a CmdRunner "runner" initialized with exec.Cmd (path "/path/to/plugin")
    And `additionalNotesAboutCommand("/path/to/plugin")` returns "SPECIFIC_NOTES"
    When `runner.Diagnose(ctx)` is called
    Then it should return a string containing the standard "unrecognizedRemotePluginMessage"
    And the returned string should also contain "SPECIFIC_NOTES"
    # This ensures the diagnostic message is constructed as expected.

  Scenario: CmdRunner uses identity address translation
    Given a CmdRunner instance "runner"
    When its `PluginToHost("tcp", "1.2.3.4:5678")` method is called
    Then it should return "tcp", "1.2.3.4:5678", nil
    When its `HostToPlugin("unix", "/tmp/s.sock")` method is called
    Then it should return "unix", "/tmp/s.sock", nil
