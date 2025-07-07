# Source: internal/cmdrunner/process_posix.go - _pidAlive function
Feature: POSIX Process Alive Check (_pidAlive)

  Background:
    On POSIX systems, checking if a process is alive often involves sending signal 0.
    This behavior needs to be understood for reliable process monitoring in a cross-platform context.
    These scenarios assume execution on a POSIX-compliant system.

  Scenario: _pidAlive returns true for an existing, signalable process
    Given a running process with PID <TargetPID> on a POSIX system
    And the current user has permission to send signal 0 to <TargetPID>
    When `_pidAlive(<TargetPID>)` is called
    Then `os.FindProcess(<TargetPID>)` should conceptually succeed (as it doesn't error on POSIX for found/not found)
    And sending syscall.Signal(0) to the process should succeed (return no error)
    And `_pidAlive` should return true

  Scenario: _pidAlive returns false if process does not exist (signal fails)
    Given PID <NonExistentPID> does not correspond to a running process on a POSIX system
    When `_pidAlive(<NonExistentPID>)` is called
    Then `os.FindProcess(<NonExistentPID>)` conceptually succeeds
    And sending syscall.Signal(0) to the process should fail (e.g., with ESRCH - No such process)
    And `_pidAlive` should return false

  Scenario: _pidAlive returns false if user lacks permission to signal the process
    Given a running process with PID <TargetPID> on a POSIX system, owned by a different user
    And the current user does NOT have permission to send signal 0 to <TargetPID>
    When `_pidAlive(<TargetPID>)` is called
    Then `os.FindProcess(<TargetPID>)` conceptually succeeds
    And sending syscall.Signal(0) to the process should fail (e.g., with EPERM - Operation not permitted)
    And `_pidAlive` should return false

  Scenario: _pidAlive handles PID 0 (special case, usually current process group or scheduler)
    Given PID 0 on a POSIX system
    When `_pidAlive(0)` is called
    Then the behavior of sending signal 0 to PID 0 (which often succeeds if any process in group exists or for scheduler) is tested
    And `_pidAlive` should return true if the signal call succeeds, false otherwise
    # This is a system-dependent edge case, but signal 0 to PID 0 usually succeeds for root or if any process in the process group exists.

  Scenario: _pidAlive handles PID -1 (special case, all processes user can signal)
    Given PID -1 on a POSIX system
    When `_pidAlive(-1)` is called
    Then the behavior of sending signal 0 to PID -1 is tested
    And `_pidAlive` should return true if the signal call succeeds, false otherwise
    # Signal 0 to -1 usually succeeds if the user can signal any process. Not typically used for checking a specific plugin.
