# Source: grpc_controller.go - grpcControllerServer
Feature: gRPC Controller Shutdown Behavior

  Background:
    The gRPC Controller service provides a mechanism for the client to request plugin termination.
    Consistent shutdown behavior is important for resource management on all platforms.

  Scenario: GRPCController Shutdown RPC call invokes Stop on the main GRPCServer
    Given a `grpcControllerServer` is initialized with a reference to a main `GRPCServer` instance "main_grpc_server"
    And "main_grpc_server" is running
    When the `Shutdown` RPC method of the `grpcControllerServer` is called (e.g., by a GRPCClient during its Close sequence)
    Then the `Stop()` method of "main_grpc_server" should be invoked
    And the `Shutdown` RPC method should return an empty response and no error

  # TODO: When the GracefulStop issue (mentioned in grpc_controller.go comments) is resolved,
  # this feature should be updated to reflect the intended graceful shutdown behavior.
  # For example:
  # Scenario: GRPCController Shutdown RPC call invokes GracefulStop on the main GRPCServer (Future State)
  #   Given a `grpcControllerServer` is initialized with a reference to a main `GRPCServer` instance "main_grpc_server"
  #   And "main_grpc_server" is running
  #   When the `Shutdown` RPC method of the `grpcControllerServer` is called
  #   Then the `GracefulStop()` method of "main_grpc_server" should be invoked
  #   And the `Shutdown` RPC method should return an empty response and no error
