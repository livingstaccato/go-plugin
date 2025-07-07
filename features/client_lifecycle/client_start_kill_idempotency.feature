# Source: client.go - Start, Kill, Exited methods
Feature: Client Start and Kill Idempotency and State Management

  Background:
    Reliable lifecycle management is key for cross-platform stability.

  Scenario: Calling Start on an already started client has no effect
    Given a plugin client configured with a "mock" helper process
    When the client's Start method is called successfully, returning an address "addr1"
    And the client's Start method is called again
    Then the second call should also return the same address "addr1"
    And no error should occur
    And the plugin process should not be restarted
    And the client is subsequently killed

  Scenario: Calling Kill on a client that was never started has no effect
    Given a plugin client is configured but not started
    When the client's Kill method is called
    Then the call should complete without error or attempting to kill a process

  Scenario: Calling Kill multiple times on a started client
    Given a plugin client configured with a "mock" helper process and started successfully
    When the client's Kill method is called
    And the client eventually reports as exited
    And the client's Kill method is called again
    Then the second Kill call should complete without error, effectively as a no-op
    # Ensures that repeated kills don't cause panics or unexpected behavior.

  Scenario: Exited status before and after Kill
    Given a plugin client configured with a "mock" helper process
    When the client is started successfully
    Then the client's Exited method should return false
    When the client's Kill method is called
    And sufficient time passes for the plugin to terminate
    Then the client's Exited method should return true

  Scenario: ReattachConfig returns nil if client not started
    Given a plugin client is configured but not started
    When the client's ReattachConfig method is called
    Then the result should be nil

  Scenario: ReattachConfig returns valid config after start (Cmd based)
    Given a plugin client configured with a "mock" helper process using Cmd
    When the client's Start method is called successfully
    Then the client's ReattachConfig method should return a non-nil ReattachConfig
    And the ReattachConfig should contain the correct protocol, address, and PID
    And the client is subsequently killed

  Scenario: ReattachConfig returns original config if client was reattached
    Given an initial plugin client "original_client" is started and its ReattachConfig "original_reattach_cfg" is obtained
    And "original_client" is killed
    And a new plugin client "reattached_client" is configured using "original_reattach_cfg" and started
    When "reattached_client".ReattachConfig() is called
    Then the returned ReattachConfig should be substantially the same as "original_reattach_cfg"
    And "reattached_client" is subsequently killed
