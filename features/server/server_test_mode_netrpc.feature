# Source: server_test.go - TestServer_RPC
Feature: Plugin Server Test Mode (NetRPC)

  Scenario: Server in test mode (NetRPC) provides reattach configuration and shuts down
    Given a plugin server is started in test mode with NetRPC plugins (testPluginMap) and test handshake
    And the server provides reattach configuration via a channel "reattachCh"
    And the server provides a close signal via a channel "closeCh"
    When reattach configuration is received from "reattachCh" within 2 seconds
    Then the reattach configuration should not be nil
    When the test mode server's context is canceled
    Then "closeCh" should signal completion
