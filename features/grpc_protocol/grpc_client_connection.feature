# Source: grpc_client.go
Feature: gRPC Client Connection and Lifecycle

  Background:
    The gRPC client component establishes and manages the gRPC connection,
    including TLS, custom dialers, and interaction with broker and controller services.
    Cross-platform consistency of these operations is vital.

  Scenario: newGRPCClient successfully establishes a gRPC connection and initializes components
    Given a started plugin Client "plugin_client" configured for gRPC with a valid address
    And its associated plugin server is accepting gRPC connections
    And a cancellable context "doneCtx" is provided
    When `newGRPCClient(doneCtx, plugin_client)` is called
    Then a gRPC connection (grpc.ClientConn) to "plugin_client.address" should be established using `dialGRPCConn`
      | DialOption Expectation                                       | Details                                                                 |
      | Custom dialer (plugin_client.dialer) should be used          | For Unix sockets, etc.                                                  |
      | FailOnNonTempDialError should be true                        | Ensures quick failure on permanent errors                               |
      | TransportCredentials should be insecure if TLSConfig is nil    | Correctly uses insecure.NewCredentials()                                |
      | TransportCredentials should use TLSConfig if provided        | Correctly uses credentials.NewTLS(plugin_client.config.TLSConfig)       |
      | MaxCallRecvMsgSize and MaxCallSendMsgSize should be MaxInt32 | Handles large messages                                                  |
      | Custom GRPCDialOptions from plugin_client.config should be applied | Allows user-defined dial options                                        |
    And a GRPCBrokerClient and GRPCBroker should be initialized and started
    And a GRPCStdioClient should be initialized and started
    And a GRPCClient instance should be returned with the connection, plugins, context, broker, and controller client
    And no error should be returned by `newGRPCClient`

  Scenario: newGRPCClient handles gRPC connection failure from dialGRPCConn
    Given a plugin Client "plugin_client" configured for gRPC with an invalid or unreachable address
    And a cancellable context "doneCtx"
    When `newGRPCClient(doneCtx, plugin_client)` is called
    Then `dialGRPCConn` should fail to establish a gRPC connection
    And an error should be returned by `newGRPCClient`

  Scenario: newGRPCClient handles GRPCStdioClient initialization failure
    Given a plugin Client "plugin_client" configured for gRPC and a successful gRPC connection
    And a cancellable context "doneCtx"
    And `newGRPCStdioClient` will fail upon its call
    When `newGRPCClient(doneCtx, plugin_client)` is called
    Then an error from `newGRPCStdioClient` should be returned

  Scenario: GRPCClient Close method attempts graceful shutdown
    Given a fully initialized GRPCClient "grpc_client" with an active connection, broker, and controller client
    And its associated plugin server is responsive
    When "grpc_client.Close()" is called
    Then the GRPCBroker's Close method should be invoked
    And the GRPCController's Shutdown RPC method should be called using the client's "doneCtx"
    And the underlying grpc.ClientConn's Close method should be invoked
    # This ensures a multi-step shutdown process for gRPC resources.

  Scenario: GRPCClient Dispense method correctly uses GRPCPlugin interface
    Given a fully initialized GRPCClient "grpc_client" configured with a "test_grpc_plugin" that implements GRPCPlugin
    When "grpc_client.Dispense(\"test_grpc_plugin\")" is called
    Then the "test_grpc_plugin"'s GRPCPlugin.GRPCClient method should be called with the client's "doneCtx", broker, and gRPC connection
    And the result of that GRPCPlugin.GRPCClient call should be returned

  Scenario: GRPCClient Dispense fails for a non-GRPCPlugin
    Given a fully initialized GRPCClient "grpc_client" configured with a "test_netrpc_plugin" that only implements the base Plugin interface
    When "grpc_client.Dispense(\"test_netrpc_plugin\")" is called
    Then an error should be returned indicating the plugin does not support gRPC

  Scenario: GRPCClient Ping method uses gRPC Health Checking service
    Given a fully initialized GRPCClient "grpc_client" with an active connection to a server supporting gRPC Health Checking
    When "grpc_client.Ping()" is called
    Then a HealthCheckRequest for service "go-plugin" should be sent via the gRPC HealthClient
    And the error from this health check call should be returned
    # Platform network differences should not affect the ability to use the standard gRPC health check.
