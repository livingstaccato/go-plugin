# Source: server_test.go - TestServer_testMode_AutoMTLS
Feature: Plugin Server Test Mode with AutoMTLS (gRPC)

  Scenario: Server in test mode with AutoMTLS allows versioned gRPC client connection and interaction
    Given a plugin server is started in test mode with versioned gRPC plugins (version 2), versioned handshake, and a null logger
    And a helper process "test-mtls" is available
    When a plugin client is configured with the "test-mtls" process, versioned handshake, version 2 gRPC plugins, AutoMTLS enabled, and allowing gRPC
    And the client connects and obtains an RPC interface
    Then a ping to the client should be successful
    And the "test" plugin can be dispensed from the client
    And the dispensed plugin should be a valid "testInterface"
    And calling the "Double" method on the "test" plugin with input 3 should return 6
    And calling the "Bidirectional" method on the "test" plugin should succeed
    When the client is killed
    And the test mode server's context is canceled
    Then the server's close channel should signal completion
