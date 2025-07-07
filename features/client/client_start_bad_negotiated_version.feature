# Source: client_test.go - TestClientStart_badNegotiatedVersion
Feature: Client Start Failure Scenarios

  Scenario: Client fails to start if negotiated protocol version is incompatible
    Given a helper process "test-versioned-plugins" that only supports plugin protocol version 2
    And a plugin client configured with this process, a handshake for version 1, and single-version plugin map
    And a 50ms start timeout
    When the plugin client attempts to start
    Then an error should occur during client start
    # This implies a version mismatch during handshake negotiation.
