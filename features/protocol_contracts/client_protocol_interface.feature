# Source: protocol.go - ClientProtocol interface
Feature: ClientProtocol Interface Contract

  Background:
    The `ClientProtocol` interface defines the essential operations for any plugin client implementation
    that communicates with a plugin server. A clear contract is vital for robust cross-platform interactions.

  Scenario: A ClientProtocol implementation must support dispensing plugins
    Given a concrete implementation "myClientProto" of the `ClientProtocol` interface, successfully connected to a server
    And the server offers a plugin named "service_A"
    When "myClientProto.Dispense(\"service_A\")" is called
    Then it must return a usable client instance for "service_A"
    And it must return a nil error
    # This ensures the client can access specific plugin functionalities.

  Scenario: A ClientProtocol implementation must handle dispensing unknown plugins
    Given a concrete implementation "myClientProto" of the `ClientProtocol` interface, successfully connected to a server
    And the server does NOT offer a plugin named "unknown_service"
    When "myClientProto.Dispense(\"unknown_service\")" is called
    Then it must return a nil client instance
    And it must return a non-nil error indicating the plugin is unknown or unavailable
    # Clear error reporting for missing plugins is crucial for diagnostics.

  Scenario: A ClientProtocol implementation must support pinging the server
    Given a concrete implementation "myClientProto" of the `ClientProtocol` interface, successfully connected to a responsive server
    When "myClientProto.Ping()" is called
    Then it must return a nil error, indicating the connection and server are healthy
    # Ping is a fundamental health check for the plugin communication channel.

  Scenario: A ClientProtocol implementation must handle ping failure
    Given a concrete implementation "myClientProto" of the `ClientProtocol` interface
    And the connection to the server is broken or the server is unresponsive
    When "myClientProto.Ping()" is called
    Then it must return a non-nil error, indicating the ping failed
    # This allows the host to detect communication issues.

  Scenario: A ClientProtocol implementation must support closing the connection
    Given a concrete implementation "myClientProto" of the `ClientProtocol` interface, with an active connection
    When "myClientProto.Close()" is called
    Then all underlying resources (e.g., network connections, streams) associated with this protocol client should be released
    And it should attempt a graceful shutdown if the protocol supports it (e.g., notifying the server)
    And it must return an error if the close operation encounters issues, or nil if successful
    # Proper resource cleanup and shutdown notification are essential on all platforms.
    # Subsequent operations on the closed client should fail.
