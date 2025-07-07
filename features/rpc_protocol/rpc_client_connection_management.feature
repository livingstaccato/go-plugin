# Source: rpc_client.go
Feature: RPC Client Connection Management (NetRPC)

  Background:
    The RPCClient component manages the NetRPC connection, including multiplexing via yamux,
    TLS, and control/data streams. Ensuring these aspects work reliably is key for cross-platform porting.

  Scenario: newRPCClient successfully establishes a connection and sets up RPCClient
    Given a started plugin Client "plugin_client" with a valid NetRPC address and configuration
    And the plugin at "plugin_client.address" is accepting connections
    When `newRPCClient(plugin_client)` is called
    Then a network connection to "plugin_client.address" should be established
    And TCP KeepAlive should be set on the connection if it's TCP
    And if TLS is configured in "plugin_client.config.TLSConfig", the connection should be wrapped with TLS
    And a yamux client session should be established over the connection
    And a control RPC stream should be opened via yamux
    And stdout and stderr data streams should be opened via yamux
    And a MuxBroker should be initialized and started
    And an RPCClient instance should be returned with the control client, broker, and streams configured
    And SyncStreams should be initiated for the new RPCClient
    And no error should be returned by `newRPCClient`

  Scenario: newRPCClient handles connection failure
    Given a started plugin Client "plugin_client" with an invalid or unreachable NetRPC address
    When `newRPCClient(plugin_client)` is called
    Then it should fail to establish a network connection
    And an error should be returned

  Scenario: NewRPCClient (direct) handles yamux client setup failure
    Given an established I/O ReadWriteCloser "conn"
    And a map of plugins
    And the "conn" will cause yamux.Client setup to fail (e.g., by being closed prematurely)
    When `NewRPCClient(conn, plugins)` is called
    Then an error related to yamux client creation should be returned
    And "conn" should be closed

  Scenario: NewRPCClient (direct) handles yamux stream opening failure
    Given an established I/O ReadWriteCloser "conn" and a working yamux.Client "mux" over it
    And a map of plugins
    And "mux.Open()" will fail for control or data streams
    When `NewRPCClient(conn, plugins)` is called
    Then an error related to opening yamux streams should be returned
    And "mux" (and underlying "conn") should be closed

  Scenario: RPCClient Close method attempts graceful shutdown via Control.Quit
    Given a fully initialized and connected RPCClient "rpc_client"
    And its associated plugin server is responsive
    When "rpc_client.Close()" is called
    Then a "Control.Quit" RPC call should be made to the plugin server
    And the control, stdout, stderr, and MuxBroker connections should be closed
    And if "Control.Quit" succeeds, no error should be returned by Close()
    And if "Control.Quit" fails, its error should be returned by Close()
    # Consistent shutdown behavior is vital for resource cleanup on all platforms.

  Scenario: RPCClient Dispense method correctly sets up a plugin-specific RPC client
    Given a fully initialized RPCClient "rpc_client" configured with a "test_plugin"
    And the plugin server's Dispenser service is ready to dispense "test_plugin" on stream ID 123
    And the RPCClient's MuxBroker can dial stream ID 123
    When "rpc_client.Dispense(\"test_plugin\")" is called
    Then a "Dispenser.Dispense" RPC call for "test_plugin" should be made, returning stream ID 123
    And the MuxBroker should dial stream ID 123 to get a new connection
    And the "test_plugin"'s Plugin.Client method should be called with the MuxBroker and a new rpc.Client over the dialed connection
    And the result of Plugin.Client should be returned by Dispense
    # This ensures that plugin-specific communication channels are correctly established.

  Scenario: RPCClient Ping method sends Control.Ping
    Given a fully initialized and connected RPCClient "rpc_client"
    When "rpc_client.Ping()" is called
    Then a "Control.Ping" RPC call should be made to the plugin server
    And the error from this RPC call should be returned
    # Platform network differences should not affect the ability to send this control message.
