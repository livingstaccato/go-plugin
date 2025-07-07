# Source: server.go - Serve function, protocolVersion function
Feature: Server-Side Handshake Protocol and Version Negotiation

  Background:
    The plugin server must correctly interpret client handshake information and respond with its own capabilities.
    This is critical for establishing a compatible communication channel across different platforms and plugin versions.

  Scenario: Server validates Magic Cookie from environment variables (non-test mode)
    Given the plugin server is started via `Serve` with HandshakeConfig (Key "K", Value "V")
    And the environment variable "K" is set to "V" (matching the MagicCookie)
    And the server is NOT in test mode
    When the server initializes
    Then the magic cookie validation should pass
    And the server should proceed with startup

  Scenario: Server exits if Magic Cookie validation fails (non-test mode)
    Given the plugin server is started via `Serve` with HandshakeConfig (Key "K", Value "V")
    And the environment variable "K" is set to "WRONG_VALUE" (not matching the MagicCookie)
    And the server is NOT in test mode
    When the server initializes
    Then the server should print an error message to stderr about direct execution or mismatched cookie
    And the server process should exit with status code 1

  Scenario: Server skips Magic Cookie validation in test mode
    Given the plugin server is started via `Serve` with HandshakeConfig (Key "K", Value "V")
    And the environment variable "K" is NOT set or has a wrong value
    And the server IS in test mode (ServeConfig.Test is not nil)
    When the server initializes
    Then the magic cookie validation should be skipped
    And the server should proceed with startup

  Scenario Outline: Server negotiates correct protocol version based on its config and client's PLUGIN_PROTOCOL_VERSIONS env var
    Given a ServeConfig with VersionedPlugins supporting versions <ServerVersions> for a <PluginType> plugin
    And the environment variable PLUGIN_PROTOCOL_VERSIONS is set to "<ClientAnnouncedVersions>"
    When the server's `protocolVersion` logic is invoked
    Then the negotiated protocol version should be <ExpectedNegotiatedVersion>
    And the selected plugin set should correspond to <ExpectedNegotiatedVersion>
    And the protocol type should be <ExpectedProtocolType>

    Examples:
      | ServerVersions | PluginType | ClientAnnouncedVersions | ExpectedNegotiatedVersion | ExpectedProtocolType | Notes                                        |
      | [1, 2]         | NetRPC     | "2,1"                   | 2                         | netrpc               | Client prefers newer, server supports        |
      | [1, 2]         | gRPC       | "1"                     | 1                         | grpc                 | Client only supports older, server supports    |
      | [2]            | NetRPC     | "1"                     | 2                         | netrpc               | No common version, server defaults to its own (client would later fail) |
      | [1]            | gRPC       | "2,1"                   | 1                         | grpc                 | Client prefers newer, server only has older  |
      | [1]            | NetRPC     | "" (empty or not set)   | 1                         | netrpc               | Legacy client, server provides its version   |
      # Note: The "No common version" example implies the server picks one of its own versions.
      # The client is then responsible for erroring if that version is not in its own supported list.

  Scenario: Server correctly constructs and prints handshake string to stdout (non-test mode)
    Given a plugin server is configured to serve a version 1 NetRPC plugin
    And the server successfully starts a listener on "tcp" at "127.0.0.1:DYNAMIC_PORT"
    And the server is NOT in test mode
    And AutoMTLS is NOT enabled
    And gRPC multiplexing is NOT requested by client
    When the server is ready to announce its connection details
    Then it should print a handshake string to stdout matching the format "CORE_VERSION|1|tcp|127.0.0.1:DYNAMIC_PORT|netrpc||"
      | CORE_VERSION should be 1                                                    |
      | Server certificate part should be empty                                     |
      | Multiplexing support part should be absent or empty if client didn't ask    |
    And stdout should be flushed

  Scenario: Server includes AutoMTLS server certificate in handshake string if applicable
    Given a plugin server is configured
    And the client has provided its certificate via PLUGIN_CLIENT_CERT environment variable (triggering AutoMTLS on server)
    And the server generates its own one-time certificate for AutoMTLS
    When the server prints the handshake string
    Then the handshake string should include a base64 encoded server certificate in the 6th part
    And this certificate should be the raw ASN.1 data of the generated leaf certificate

  Scenario: Server includes gRPC multiplexing support in handshake string if client requested
    Given a plugin server is configured for gRPC
    And the client has indicated support/request for gRPC multiplexing via envMultiplexGRPC
    When the server prints the handshake string
    Then the handshake string should include "|true" as the 7th part indicating multiplexing support

  Scenario: Server sends ReattachConfig via channel in test mode instead of printing to stdout
    Given a plugin server is started in test mode with `ServeTestConfig.ReattachConfigCh` set to a valid channel
    And the server is configured for version 1 NetRPC and listens on "tcp" at "127.0.0.1:DYNAMIC_PORT"
    When the server is ready with connection details
    Then a ReattachConfig should be sent to `ReattachConfigCh`
    And the ReattachConfig should contain:
      | Field           | Expected Value                  |
      | Protocol        | netrpc                          |
      | ProtocolVersion | 1                               |
      | Addr            | (matching listener address)     |
      | Pid             | (current process ID)            |
      | Test            | true                            |
    And no handshake string should be printed to standard stdout.
