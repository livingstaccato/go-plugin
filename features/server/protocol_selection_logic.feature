# Source: server_test.go - TestProtocolSelection_no_server
Feature: Server Protocol Selection Logic

  Scenario: protocolVersion function selects gRPC when GRPCServer is configured
    Given a ServeConfig with versioned gRPC plugins (version 2), test versioned handshake, and a GRPCServer implementation
    And TLSProvider is configured
    When the internal protocolVersion function is evaluated with this config
    Then the selected protocol should be "ProtocolGRPC"

  Scenario: protocolVersion function selects NetRPC when GRPCServer is not configured
    Given a ServeConfig with versioned gRPC plugins (version 2) and test versioned handshake
    And GRPCServer implementation is nil
    And TLSProvider is configured
    When the internal protocolVersion function is evaluated with this config
    Then the selected protocol should be "ProtocolNetRPC"
