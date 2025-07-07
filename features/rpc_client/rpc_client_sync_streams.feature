# Source: rpc_client_test.go - TestClient_syncStreams
Feature: RPC Client Stream Synchronization (NetRPC)

  Scenario: RPC client correctly synchronizes stdout and stderr streams from the server side
    Given an RPC client is established using TestPluginRPCConn
    And server-side stdout is simulated by an io.Pipe "server_stdout_pipe"
    And server-side stderr is simulated by an io.Pipe "server_stderr_pipe"
    And the client is configured to use these server pipes via TestOptions
    And a buffer "client_stdout_capture" is prepared for capturing synced stdout
    And a buffer "client_stderr_capture" is prepared for capturing synced stderr
    When the client's SyncStreams method is called to sync to "client_stdout_capture" and "client_stderr_capture"
    And "stdouttest" is written to the input of "server_stdout_pipe"
    And "stderrtest" is written to the input of "server_stderr_pipe"
    And a short time passes for synchronization
    And the client and pipes are closed
    Then the "client_stdout_capture" buffer should contain "stdouttest"
    And the "client_stderr_capture" buffer should contain "stderrtest"
