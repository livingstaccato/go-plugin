# Source: server_test.go - TestServer_testMode
Feature: Plugin Server Test Mode (gRPC)

  Scenario: Server in test mode allows client reattachment and controlled shutdown
    Given a plugin server is started in test mode with gRPC plugins and test handshake
    And the server provides reattach configuration via a channel
    When reattach configuration is received from the server
    Then the reattach configuration should not be nil
    And the reattach configuration protocol version should match the test handshake

    Given the received reattach configuration for the test mode server
    When a plugin client is configured with this reattach information, gRPC plugins, and allowing gRPC
    And the client connects and obtains an RPC interface
    Then a ping to the client should be successful
    When the client is instructed to Kill itself (which should be a no-op for test mode reattach)
    Then a ping to the client should still be successful
    When the test mode server's context is canceled
    And the server's close channel signals completion
    Then a subsequent ping to the client should fail
    And the server should have logged "HELLO" via t.Logf (manual verification)
