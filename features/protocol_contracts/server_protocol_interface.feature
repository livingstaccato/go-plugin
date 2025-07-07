# Source: protocol.go - ServerProtocol interface
Feature: ServerProtocol Interface Contract

  Background:
    The `ServerProtocol` interface defines the essential operations for any plugin server implementation.
    Adherence to this contract is critical for ensuring that the plugin host can correctly manage
    and interact with different plugin protocol implementations, especially in a cross-platform context.

  Scenario: A ServerProtocol implementation must successfully initialize
    Given a concrete implementation "myServerProto" of the `ServerProtocol` interface
    When its `Init()` method is called
    Then the method should perform all necessary setup and validation for the protocol
    And if initialization is successful, it must return a nil error
    And if initialization fails, it must return a non-nil error detailing the cause
    # Platform-specific initialization details should be handled within the Init method.

  Scenario: A ServerProtocol implementation must provide its configuration string
    Given an initialized `ServerProtocol` implementation "myServerProto"
    When its `Config()` method is called
    Then it must return a string representing extra configuration for the client
    And this string may be empty if no extra configuration is needed
    And the returned string will be base64 encoded by the framework before being sent to the client
    # This configuration string allows protocols to pass specific setup data to their client counterparts.
    # The format of this string is protocol-dependent but must be serializable.

  Scenario: A ServerProtocol implementation must serve connections on a listener
    Given an initialized `ServerProtocol` implementation "myServerProto"
    And a net.Listener "active_listener" is ready to accept connections
    When its `Serve(active_listener)` method is called
    Then the implementation must begin accepting and handling connections from "active_listener"
    And this method should block until "active_listener" is closed or another termination condition is met
    # This is the main loop for the protocol server, and its behavior upon listener errors or closure
    # should be consistent and lead to a clean shutdown of the protocol serving.
