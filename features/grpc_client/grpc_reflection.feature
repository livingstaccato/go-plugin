# Source: grpc_client_test.go - TestGRPC_Reflection
Feature: gRPC Client Service Reflection

  Background:
    Given a list of expected core gRPC services:
      | serviceName                         |
      | grpc.health.v1.Health               |
      | grpc.reflection.v1.ServerReflection   |
      | grpc.reflection.v1alpha.ServerReflection |
      | grpctest.Test                       |
      | plugin.GRPCBroker                   |
      | plugin.GRPCController               |
      | plugin.GRPCStdio                    |
    And a list of expected methods for "grpc.health.v1.Health" service:
      | methodName |
      | Check      |
      | Watch      |

  Scenario: Default gRPC client can list services and resolve service methods using reflection
    Given a test gRPC connection is established (mode: default) with a "testGRPCInterfacePlugin"
    And a gRPC reflection client is created for the connection
    When the reflection client lists available services
    Then the list of services should match the expected core gRPC services
    And no error should occur during listing services
    When the reflection client resolves the "grpc.health.v1.Health" service
    Then the methods of the service should match the expected methods for "grpc.health.v1.Health"
    And no error should occur during resolving the service

  Scenario: Multiplexed gRPC client can list services and resolve service methods using reflection
    Given a test gRPC connection is established (mode: multiplexed) with a "testGRPCInterfacePlugin"
    And a gRPC reflection client is created for the connection
    When the reflection client lists available services
    Then the list of services should match the expected core gRPC services
    And no error should occur during listing services
    When the reflection client resolves the "grpc.health.v1.Health" service
    Then the methods of the service should match the expected methods for "grpc.health.v1.Health"
    And no error should occur during resolving the service
