# Source: internal/cmdrunner/process_windows.go - _pidAlive function
Feature: Windows Process Alive Check (_pidAlive)

  Background:
    On Windows, checking if a process is alive involves using Windows API calls like OpenProcess and GetExitCodeProcess.
    This behavior needs to be understood for reliable process monitoring in a cross-platform context.
    These scenarios assume execution on a Windows system.

  Scenario: _pidAlive returns true for an existing, active process
    Given a running process with PID <TargetPID> on a Windows system
    And the current user has sufficient permissions to open the process with desired access rights
    When `_pidAlive(<TargetPID>)` is called
    Then `syscall.OpenProcess(<TargetPID>)` should succeed and return a valid process handle
    And `syscall.GetExitCodeProcess` for that handle should succeed
    And the retrieved exit code should be STILL_ACTIVE (259)
    And `_pidAlive` should return true
    And the process handle should be closed

  Scenario: _pidAlive returns false if process does not exist
    Given PID <NonExistentPID> does not correspond to a running process on a Windows system
    When `_pidAlive(<NonExistentPID>)` is called
    Then `syscall.OpenProcess(<NonExistentPID>)` should fail (e.g., with ERROR_INVALID_PARAMETER)
    And `_pidAlive` should return false

  Scenario: _pidAlive returns false if user lacks permission to open the process
    Given a running process with PID <TargetPID> on a Windows system
    And the current user does NOT have sufficient permissions (e.g., `processDesiredAccess`) for <TargetPID>
    When `_pidAlive(<TargetPID>)` is called
    Then `syscall.OpenProcess(<TargetPID>)` should fail (e.g., with ERROR_ACCESS_DENIED)
    And `_pidAlive` should return false

  Scenario: _pidAlive returns false for a process that has exited
    Given a process with PID <ExitedPID> on a Windows system that has already terminated with an exit code (e.g., 0)
    And the current user can open the process handle (process object might still exist briefly)
    When `_pidAlive(<ExitedPID>)` is called
    Then `syscall.OpenProcess(<ExitedPID>)` may succeed
    And `syscall.GetExitCodeProcess` should retrieve an exit code NOT equal to STILL_ACTIVE (259)
    And `_pidAlive` should return false
    And the process handle should be closed

  Scenario: _pidAlive returns false if GetExitCodeProcess fails for an open handle
    Given a running process with PID <TargetPID> for which `syscall.OpenProcess` succeeds
    But `syscall.GetExitCodeProcess` subsequently fails with an error for an unexpected reason
    When `_pidAlive(<TargetPID>)` is called
    Then `_pidAlive` should return false
    And the process handle should be closed
