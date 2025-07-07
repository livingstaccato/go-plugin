# Source: client.go - Start method
Feature: Client-Plugin Handshake Process and Environment

  Background:
    The handshake is critical for establishing communication and versioning, with environment variables playing a key role.
    Cross-platform consistency in how these are handled is important.

  Scenario: Client sets necessary environment variables for plugin handshake
    Given a plugin client is configured with a "mock" helper process, handshake config (key "K", value "V", version 1), min port 1000, max port 2000
    And the client is configured to support plugin protocol versions [1, 2]
    When the client prepares to start the plugin command
    Then the command's environment variables should include:
      | Variable                 | Expected Value Pattern        |
      | K                        | V                             |
      | PLUGIN_MIN_PORT          | 1000                          |
      | PLUGIN_MAX_PORT          | 2000                          |
      | PLUGIN_PROTOCOL_VERSIONS | contains "1" and contains "2" |
    # Ensuring these environment variables are correctly passed is vital for the plugin to initialize properly.

  Scenario: Client correctly parses valid handshake string from plugin stdout
    Given a plugin client is configured and initiated to start a "mock" plugin
    And the plugin's stdout emits a valid handshake string: "CORE_VERSION|PLUGIN_VERSION|NETWORK_TYPE|NETWORK_ADDRESS|PROTOCOL_TYPE|SERVER_CERT_BASE64|MUX_SUPPORT_BOOL"
      | CORE_VERSION         | 1 (matches CoreProtocolVersion) |
      | PLUGIN_VERSION       | 1                               |
      | NETWORK_TYPE         | tcp                             |
      | NETWORK_ADDRESS      | 127.0.0.1:1234                  |
      | PROTOCOL_TYPE        | netrpc                          |
      | SERVER_CERT_BASE64   | (empty or valid base64)         |
      | MUX_SUPPORT_BOOL     | (empty or true/false)           |
    And the client is configured to allow "netrpc" protocol and version 1 for its plugins
    When the client processes the handshake string
    Then the client should successfully parse the address as "tcp" "127.0.0.1:1234"
    And the client should identify the protocol as "netrpc"
    And the client should negotiate plugin protocol version 1
    And if SERVER_CERT_BASE64 was provided and AutoMTLS is enabled, the server certificate should be loaded
    And if MUX_SUPPORT_BOOL was true and GRPCBrokerMultiplex is enabled, multiplexing should be acknowledged
    And the client's Start method should complete successfully

  Scenario: Client fails Start if handshake string has incompatible core protocol version
    Given a plugin client configured to start a "mock" plugin
    And the plugin's stdout emits a handshake string with core protocol version "INVALID_CORE_VERSION" (e.g., 99)
    When the client processes the handshake string
    Then the client's Start method should fail with an error indicating incompatible core API version

  Scenario: Client fails Start if handshake string has plugin protocol version not supported by client
    Given a plugin client configured to support only plugin protocol version [1]
    And the plugin's stdout emits a handshake string with plugin protocol version "2"
    When the client processes the handshake string
    Then the client's Start method should fail with an error indicating incompatible API version

  Scenario: Client fails Start if handshake string has unsupported protocol type
    Given a plugin client configured to allow only "netrpc" protocol
    And the plugin's stdout emits a handshake string with protocol type "fakeprotocol"
    When the client processes the handshake string
    Then the client's Start method should fail with an error indicating an unsupported plugin protocol

  Scenario: Client fails Start on malformed handshake string (too few parts)
    Given a plugin client configured to start a "mock" plugin
    And the plugin's stdout emits a malformed handshake string "1|1|tcp" (missing address and protocol)
    When the client processes the handshake string
    Then the client's Start method should fail with an error indicating an unrecognized remote plugin message

  Scenario: Client Start fails if AutoMTLS is enabled and server provides undecodable/invalid certificate
    Given a plugin client configured with AutoMTLS enabled
    And the plugin's stdout emits a handshake string with an invalid base64 server certificate
    When the client processes the handshake string
    Then the client's Start method should fail with an error related to parsing the server certificate

  Scenario: Client Start fails if GRPCBrokerMultiplex is enabled and plugin provides unparsable MUX_SUPPORT_BOOL
    Given a plugin client configured with GRPCBrokerMultiplex enabled and gRPC protocol
    And the plugin's stdout emits a handshake string with an unparsable boolean for MUX_SUPPORT_BOOL (e.g., "notabool")
    When the client processes the handshake string
    Then the client's Start method should fail with an error related to parsing multiplexing support

  Scenario: Client handles AutoMTLS certificate exchange environment variables
    Given a plugin client configured with AutoMTLS enabled
    When the client prepares to start the plugin command
    Then the command's environment variables should include "PLUGIN_CLIENT_CERT" containing the client's public certificate
    And the client's TLSConfig should be configured for mTLS using the generated one-time certificate
    And the client expects the plugin to return its public certificate in the handshake string for mTLS setup
    # This ensures the mechanism for certificate exchange is in place for mTLS.
