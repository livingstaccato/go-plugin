# Source: internal/cmdrunner/process.go - pidWait function
Feature: Generic Process Wait Logic (pidWait)

  Background:
    The generic `pidWait` function provides a polling mechanism to wait for a process to exit,
    relying on a platform-specific `pidAlive` check.

  Scenario: pidWait polls using pidAlive and exits when process is no longer alive
    Given a PID <TargetPID> for a process that is initially alive
    And the platform-specific `pidAlive(<TargetPID>)` will initially return true
    When `pidWait(<TargetPID>)` is called
    Then `pidAlive(<TargetPID>)` should be called repeatedly with a 1-second interval
    When `pidAlive(<TargetPID>)` eventually returns false (indicating process exited)
    Then the `pidWait` function should stop polling and return
    And `pidWait` should return a nil error

  Scenario: pidWait continues polling if process remains alive
    Given a PID <TargetPID> for a process that remains alive indefinitely for the test duration
    And the platform-specific `pidAlive(<TargetPID>)` consistently returns true
    When `pidWait(<TargetPID>)` is called
    Then `pidAlive(<TargetPID>)` should be called repeatedly at 1-second intervals
    And `pidWait` should continue to block as long as `pidAlive` returns true (within test timeout limits)

  # Note: The current generic pidWait implementation always returns nil.
  # Scenarios for pidWait returning errors would depend on pidAlive itself returning errors,
  # which is not how the current generic pidWait is structured to use it.
  # Platform-specific wait mechanisms might offer more detailed error reporting.
