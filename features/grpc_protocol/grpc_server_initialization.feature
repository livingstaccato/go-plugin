# Source: grpc_server.go
Feature: gRPC Server Initialization and Core Service Registration

  Background:
    A go-plugin gRPC server must initialize correctly and register essential internal services
    to function reliably across platforms.

  Scenario: GRPCServer Init successfully creates gRPC server and registers core services
    Given a GRPCServer instance "grpc_srv" configured with:
      | Field          | Value                                     |
      | Plugins        | a map containing a valid GRPCPlugin "myplugin" |
      | Server         | DefaultGRPCServer factory                 |
      | TLS            | (nil or a valid *tls.Config)              |
      | Stdout/Stderr  | valid io.Readers                          |
      | Logger         | a valid hclog.Logger                      |
      | Muxer          | (nil or a valid *grpcmux.GRPCServerMuxer) |
    When "grpc_srv.Init()" is called
    Then a new grpc.Server instance should be created
    And if TLS config was provided, gRPC server credentials should be configured with it
    And the gRPC Health Checking service (grpc_health_v1.Health) should be registered on the server
    And the gRPC Reflection service (reflection.Server) should be registered
    And the GRPCBroker service (plugin.GRPCBroker) should be registered, and its broker component started
    And the GRPCController service (plugin.GRPCController) should be registered
    And the GRPCStdio service (plugin.GRPCStdio) should be registered
    And the "myplugin"'s GRPCServer method should be called to register its services
    And "grpc_srv.Init()" should return no error

  Scenario: GRPCServer Init fails if a configured plugin is not a GRPCPlugin
    Given a GRPCServer instance "grpc_srv" configured with Plugins containing an entry "not_grpc" which is not a GRPCPlugin
    When "grpc_srv.Init()" is called
    Then an error should be returned indicating that "not_grpc" is not a GRPC-compatible plugin

  Scenario: GRPCServer Init fails if a GRPCPlugin's GRPCServer registration method returns an error
    Given a GRPCServer instance "grpc_srv" configured with a GRPCPlugin "faulty_plugin" whose GRPCServer method will return an error "reg_failed"
    When "grpc_srv.Init()" is called
    Then an error should be returned indicating "error registering 'faulty_plugin': reg_failed"

  Scenario: GRPCServer Config method returns an empty JSON object string
    Given a GRPCServer instance "grpc_srv" (after Init or not)
    When "grpc_srv.Config()" is called
    Then the method should return the string "{}" (empty JSON object)
    And no panic should occur
    # This reflects the current state where GRPCServerConfig is not populated by the server.

  Scenario: GRPCServer Serve method starts serving and closes DoneCh on exit
    Given an initialized GRPCServer "grpc_srv" with a valid DoneCh
    And a net.Listener "listener"
    When "grpc_srv.Serve(listener)" is called (typically in a goroutine)
    And the underlying grpc.Server's Serve method eventually exits (e.g., due to Stop() or listener error)
    Then the "grpc_srv.DoneCh" should be closed
    And if grpc.Server.Serve returned an error, it should be logged by "grpc_srv.logger"

  Scenario: GRPCServer Stop method stops the gRPC server and closes the broker
    Given an initialized and serving GRPCServer "grpc_srv" with an active broker
    When "grpc_srv.Stop()" is called
    Then the underlying grpc.Server's Stop method should be invoked
    And the GRPCBroker's Close method should be invoked

  Scenario: GRPCServer GracefulStop method gracefully stops the gRPC server and closes the broker
    Given an initialized and serving GRPCServer "grpc_srv" with an active broker
    When "grpc_srv.GracefulStop()" is called
    Then the underlying grpc.Server's GracefulStop method should be invoked
    And the GRPCBroker's Close method should be invoked
