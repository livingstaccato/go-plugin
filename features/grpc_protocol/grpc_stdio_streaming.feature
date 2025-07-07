# Source: grpc_stdio.go
Feature: gRPC Standard I/O Streaming

  Background:
    The gRPC Stdio service facilitates streaming a plugin's stdout and stderr to the client.
    Reliable streaming and error handling are important for diagnostics across platforms.

  Scenario: copyChan reads from source and sends data chunks to a channel until EOF
    Given an io.Reader "source_reader" containing "Line1\\nLine2Part1"
    And a channel "data_dest_chan" for byte slices
    And `copyChan` is called with "source_reader" and "data_dest_chan"
    When "source_reader" provides data and then EOF
    Then "data_dest_chan" should receive byte slices corresponding to the data read from "source_reader"
      | Expected Chunk (approx) | Notes                                     |
      | "Line1\\nLine2Part1"    | Or smaller chunks if grpcStdioBuffer is hit |
    And `copyChan` should log "stdio EOF" and exit upon reaching EOF on "source_reader"

  Scenario: copyChan handles read errors from source
    Given an io.Reader "faulty_source_reader" that will return an error "read_error" after some data
    And a channel "data_dest_chan"
    And `copyChan` is called with "faulty_source_reader" and "data_dest_chan"
    When "faulty_source_reader" returns "read_error"
    Then any data read before the error should be sent to "data_dest_chan"
    And `copyChan` should log a warning about "error copying stdio data" with "read_error" and exit

  Scenario: grpcStdioServer streams data from its stdoutCh and stderrCh
    Given a `grpcStdioServer` "stdio_srv" with active stdoutCh and stderrCh
    And its `StreamStdio` gRPC method is called by a client stream "client_stream"
    When "stdout_chunk_1" is sent to "stdio_srv.stdoutCh"
    Then "client_stream" should receive a StdioData message with Channel=STDOUT and Data="stdout_chunk_1"
    When "stderr_chunk_1" is sent to "stdio_srv.stderrCh"
    Then "client_stream" should receive a StdioData message with Channel=STDERR and Data="stderr_chunk_1"
    When the "client_stream" context is done (e.g., client disconnects)
    Then the `StreamStdio` method on the server should return nil and exit its loop

  Scenario: grpcStdioServer StreamStdio handles send errors
    Given a `grpcStdioServer` "stdio_srv" streaming to "client_stream"
    When data is available on "stdio_srv.stdoutCh"
    And `client_stream.Send()` returns an error "send_error"
    Then the `StreamStdio` method on the server should return "send_error" and exit

  Scenario: newGRPCStdioClient gracefully handles unavailable Stdio service
    Given a gRPC connection "conn" to a server that does NOT implement the GRPCStdio service
    And a context "ctx" and logger "log"
    When `newGRPCStdioClient(ctx, log, conn)` is called
    Then it should log a warning "stdio service not available, stdout/stderr syncing unavailable"
    And the returned grpcStdioClient instance should have its `stdioClient` field as nil
    And no error should be returned by `newGRPCStdioClient`

  Scenario: grpcStdioClient Run method does nothing if stdioClient is nil
    Given a grpcStdioClient "stdio_client_obj" whose internal `stdioClient` (the gRPC stream client) is nil
    And io.Writer "out_writer" and "err_writer"
    When `stdio_client_obj.Run(out_writer, err_writer)` is called
    Then it should log a warning "stdio service unavailable, run will do nothing"
    And the method should return immediately without attempting to receive data

  Scenario: grpcStdioClient Run receives and writes data to correct writers
    Given a grpcStdioClient "stdio_client_obj" with an active gRPC stream `stdioClient`
    And io.Writer "out_writer" and "err_writer"
    When `stdio_client_obj.Run(out_writer, err_writer)` is called
    And `stdioClient.Recv()` returns StdioData{Channel=STDOUT, Data="out_data"}
    Then "out_data" should be written to "out_writer"
    And `stdioClient.Recv()` returns StdioData{Channel=STDERR, Data="err_data"}
    Then "err_data" should be written to "err_writer"

  Scenario Outline: grpcStdioClient Run handles specific Recv errors and EOF to terminate
    Given a grpcStdioClient "stdio_client_obj" with an active gRPC stream `stdioClient` running its Run method
    When `stdioClient.Recv()` returns an error with gRPC code <ErrorCode> or <SpecificError>
    Then the Run method should log "received EOF, stopping recv loop" (or similar for cancellation)
    And the Run method should exit

    Examples:
      | ErrorCode     | SpecificError    |
      | Canceled      |                  |
      | Unavailable   |                  |
      | Unimplemented |                  |
      |               | io.EOF           |
      |               | context.Canceled |

  Scenario: grpcStdioClient Run logs other Recv errors and terminates
    Given a grpcStdioClient "stdio_client_obj" with an active gRPC stream `stdioClient` running its Run method
    When `stdioClient.Recv()` returns an unexpected error "recv_failure" (not EOF or specific gRPC codes for clean exit)
    Then the Run method should log "error receiving data" with "recv_failure"
    And the Run method should exit
