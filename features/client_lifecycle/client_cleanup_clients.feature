# Source: client.go - CleanupClients function
Feature: Global Client Cleanup

  Background:
    Managed plugin clients need a mechanism for collective shutdown, crucial for resource management across platforms.

  Scenario: CleanupClients attempts to kill all managed clients
    Given a "managed" plugin client "client1" is created and started with a helper process "mock1"
    And another "managed" plugin client "client2" is created and started with a helper process "mock2"
    And an "unmanaged" plugin client "client3" is created and started with a helper process "mock3"
    When `CleanupClients` is called
    Then client "client1" should have its Kill method invoked
    And client "client2" should have its Kill method invoked
    And client "client3" should remain unaffected by this specific call (its Kill method not invoked by CleanupClients)
    And the global `Killed` flag should be set to 1
    # This ensures that all registered managed clients are targeted for cleanup.
    # The success of individual Kill operations depends on each plugin's state and responsiveness.

  Scenario: CleanupClients can be called when no managed clients exist
    Given no "managed" plugin clients have been created or all have been individually killed
    When `CleanupClients` is called
    Then the call should complete without error
    And the global `Killed` flag should be set to 1
    # Ensures robustness even if no clients are actively managed.

  Scenario: Calling Kill on a client after CleanupClients has run
    Given a "managed" plugin client "client1" is created and started
    When `CleanupClients` is called (which invokes client1.Kill())
    And client "client1" eventually reports as exited
    When client "client1".Kill() is called again explicitly
    Then the second Kill call should also complete, possibly as a no-op if already fully exited.
    # This tests idempotency or safe re-killing. The `Killed` flag might influence error reporting within the plugin.

  Scenario: Managed client registration
    Given a ClientConfig with Managed set to true
    When a new Client is created with this config
    Then the new client instance should be added to the global list of managed clients
    Given a ClientConfig with Managed set to false (or default)
    When a new Client is created with this config
    Then the new client instance should NOT be added to the global list of managed clients
