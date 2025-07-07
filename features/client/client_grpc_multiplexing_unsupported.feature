# Source: client_test.go - TestClient_RequestGRPCMultiplexing_UnsupportedByPlugin
Feature: Client gRPC Multiplexing Request with Unsupported Plugin

  Scenario: Client fails when requesting gRPC multiplexing from an old plugin (6-segment handshake)
    Given a helper process "mux-grpc-with-old-plugin" that simulates an old plugin unaware of multiplexing
    And a plugin client configured with this process, gRPC plugins, and gRPC multiplexing enabled
    When the plugin client attempts to start
    Then an error should occur during client start
    And the error should be "ErrGRPCBrokerMuxNotSupported"

  Scenario: Client fails when requesting gRPC multiplexing from a plugin that explicitly disables it (7-segment handshake)
    Given a helper process "mux-grpc-with-unsupported-plugin" that explicitly disables multiplexing
    And a plugin client configured with this process, gRPC plugins, and gRPC multiplexing enabled
    When the plugin client attempts to start
    Then an error should occur during client start
    And the error should be "ErrGRPCBrokerMuxNotSupported"
