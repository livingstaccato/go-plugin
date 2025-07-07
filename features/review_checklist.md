# BDD Feature Review Checklist

This checklist provides an overview of all generated BDD feature files for human review.
- `[x]` indicates the feature file has been generated.
- `[ ]` indicates the feature file is pending human review for accuracy, completeness, and relevance to cross-platform porting.

| Covered | Reviewed | Feature File Link                                                      | Details (Source File - Function/Concept) |
|:-------:|:--------:|------------------------------------------------------------------------|------------------------------------------|
| [x]     | [ ]      | [client_basic.feature](./client/client_basic.feature)                  | `client_test.go` - `TestClient`        |
| [x]     | [ ]      | [client_cleanup.feature](./client/client_cleanup.feature)                | `client_test.go` - `TestClient_testCleanup` |
| [x]     | [ ]      | [client_cmd_and_reattach.feature](./client/client_cmd_and_reattach.feature) | `client_test.go` - `TestClient_cmdAndReattach` |
| [x]     | [ ]      | [client_grpc_interface.feature](./client/client_grpc_interface.feature)    | `client_test.go` - `TestClient_grpc`   |
| [x]     | [ ]      | [client_grpc_multiplexing_unsupported.feature](./client/client_grpc_multiplexing_unsupported.feature) | `client_test.go` - `TestClient_RequestGRPCMultiplexing_UnsupportedByPlugin` |
| [x]     | [ ]      | [client_grpc_server_crash.feature](./client/client_grpc_server_crash.feature) | `client_test.go` - `TestClient_grpc_servercrash` |
| [x]     | [ ]      | [client_grpc_sync_stdio.feature](./client/client_grpc_sync_stdio.feature)  | `client_test.go` - `TestClient_grpcSyncStdio` |
| [x]     | [ ]      | [client_handshake_details.feature](./client/client_handshake_details.feature) | `client.go` - Handshake sequence in `Start()` |
| [x]     | [ ]      | [client_kill_start.feature](./client/client_kill_start.feature)            | `client_test.go` - `TestClient_killStart` |
| [x]     | [ ]      | [client_legacy_client_version_negotiation.feature](./client/client_legacy_client_version_negotiation.feature) | `client_test.go` - `TestClient_legacyClient` |
| [x]     | [ ]      | [client_legacy_server_version_negotiation.feature](./client/client_legacy_server_version_negotiation.feature) | `client_test.go` - `TestClient_legacyServer` |
| [x]     | [ ]      | [client_log_stderr_method.feature](./client/client_log_stderr_method.feature) | `client_test.go` - `TestClient_logStderr` |
| [x]     | [ ]      | [client_log_stderr_parse_json.feature](./client/client_log_stderr_parse_json.feature) | `client_test.go` - `TestClient_logStderrParseJSON` |
| [x]     | [ ]      | [client_mtls_grpc.feature](./client/client_mtls_grpc.feature)              | `client_test.go` - `TestClient_mtlsClient` (gRPC part) |
| [x]     | [ ]      | [client_mtls_netrpc.feature](./client/client_mtls_netrpc.feature)            | `client_test.go` - `TestClient_mtlsNetRPCClient` |
| [x]     | [ ]      | [client_no_stdout_scanner_race.feature](./client/client_no_stdout_scanner_race.feature) | `client_test.go` - `TestClient_noStdoutScannerRace` |
| [x]     | [ ]      | [client_ping.feature](./client/client_ping.feature)                      | `client_test.go` - `TestClient_ping`   |
| [x]     | [ ]      | [client_plugin_logging.feature](./client/client_plugin_logging.feature)      | `client_test.go` - `TestClient_logger` |
| [x]     | [ ]      | [client_reattach_grpc.feature](./client/client_reattach_grpc.feature)        | `client_test.go` - `TestClient_reattachGRPC` |
| [x]     | [ ]      | [client_reattach_netrpc.feature](./client/client_reattach_netrpc.feature)      | `client_test.go` - `TestClient_reattach` |
| [x]     | [ ]      | [client_reattach_no_protocol_netrpc.feature](./client/client_reattach_no_protocol_netrpc.feature) | `client_test.go` - `TestClient_reattachNoProtocol` |
| [x]     | [ ]      | [client_reattach_not_found.feature](./client/client_reattach_not_found.feature) | `client_test.go` - `TestClient_reattachNotFound` |
| [x]     | [ ]      | [client_secure_config.feature](./client/client_secure_config.feature)        | `client_test.go` - `TestClient_SecureConfig` |
| [x]     | [ ]      | [client_secure_config_and_reattach.feature](./client/client_secure_config_and_reattach.feature) | `client_test.go` - `TestClient_secureConfigAndReattach` |
| [x]     | [ ]      | [client_skip_host_env.feature](./client/client_skip_host_env.feature)        | `client_test.go` - `TestClient_SkipHostEnv` |
| [x]     | [ ]      | [client_start_bad_negotiated_version.feature](./client/client_start_bad_negotiated_version.feature) | `client_test.go` - `TestClientStart_badNegotiatedVersion` |
| [x]     | [ ]      | [client_start_bad_version.feature](./client/client_start_bad_version.feature) | `client_test.go` - `TestClientStart_badVersion` |
| [x]     | [ ]      | [client_start_timeout.feature](./client/client_start_timeout.feature)        | `client_test.go` - `TestClient_Start_Timeout` |
| [x]     | [ ]      | [client_stderr_capture.feature](./client/client_stderr_capture.feature)      | `client_test.go` - `TestClient_Stderr` |
| [x]     | [ ]      | [client_stderr_json_processing.feature](./client/client_stderr_json_processing.feature) | `client_test.go` - `TestClient_StderrJSON` |
| [x]     | [ ]      | [client_stdin_passthrough.feature](./client/client_stdin_passthrough.feature) | `client_test.go` - `TestClient_Stdin`  |
| [x]     | [ ]      | [client_test_interface.feature](./client/client_test_interface.feature)      | `client_test.go` - `TestClient_testInterface` |
| [x]     | [ ]      | [client_text_log_level.feature](./client/client_text_log_level.feature)      | `client_test.go` - `TestClient_textLogLevel` |
| [x]     | [ ]      | [client_tls_grpc.feature](./client/client_tls_grpc.feature)                | `client_test.go` - `TestClient_TLS_grpc` |
| [x]     | [ ]      | [client_tls_netrpc.feature](./client/client_tls_netrpc.feature)              | `client_test.go` - `TestClient_TLS`    |
| [x]     | [ ]      | [client_versioned_negotiation_and_crash.feature](./client/client_versioned_negotiation_and_crash.feature) | `client_test.go` - `TestClient_versionedClient` |
| [x]     | [ ]      | [client_wrong_version_grpc.feature](./client/client_wrong_version_grpc.feature) | `client_test.go` - `TestClient_wrongVersion` |
| [x]     | [ ]      | [client_config_defaults.feature](./client_config/client_config_defaults.feature) | `client.go` - `NewClient`, `ClientConfig` |
| [x]     | [ ]      | [client_config_validation.feature](./client_config/client_config_validation.feature) | `client.go` - `Start` validations    |
| [x]     | [ ]      | [client_cleanup_clients.feature](./client_lifecycle/client_cleanup_clients.feature) | `client.go` - `CleanupClients`, `NewClient` (Managed) |
| [x]     | [ ]      | [client_start_kill_idempotency.feature](./client_lifecycle/client_start_kill_idempotency.feature) | `client.go` - `Start`, `Kill`, `Exited`, `ReattachConfig` |
| [x]     | [ ]      | [client_stderr_log_parsing_logic.feature](./client_logging/client_stderr_log_parsing_logic.feature) | `client.go` - `logStderr`            |
| [x]     | [ ]      | [test_interface_reattach.feature](./client_posix/test_interface_reattach.feature) | `client_posix_test.go` - `TestClient_testInterfaceReattach` |
| [x]     | [ ]      | [mtls_cert_generation.feature](./client_security/mtls_cert_generation.feature) | `mtls.go` - `generateCert`           |
| [x]     | [ ]      | [secure_config_check.feature](./client_security/secure_config_check.feature) | `client.go` - `SecureConfig.Check` |
| [x]     | [ ]      | [client_unix_socket_group.feature](./client_unix/client_unix_socket_group.feature) | `client_unix_test.go` - `TestSetGroup` |
| [x]     | [ ]      | [plugin_discovery.feature](./discovery/plugin_discovery.feature)           | `discover.go` - `Discover`           |
| [x]     | [ ]      | [basic_error_implements_error.feature](./error/basic_error_implements_error.feature) | `error_test.go` - `TestBasicError_ImplementsError` |
| [x]     | [ ]      | [basic_error_matches_message.feature](./error/basic_error_matches_message.feature) | `error_test.go` - `TestBasicError_MatchesMessage` |
| [x]     | [ ]      | [new_basic_error_nil.feature](./error/new_basic_error_nil.feature)           | `error_test.go` - `TestNewBasicError_nil` |
| [x]     | [ ]      | [basic_netrpc_greeter.feature](./examples/basic_netrpc_greeter.feature)        | `examples/basic/*` - Full example flow |
| [x]     | [ ]      | [bidirectional_grpc_kv.feature](./examples/bidirectional_grpc_kv.feature)      | `examples/bidirectional/*` - Full example flow |
| [x]     | [ ]      | [grpc_netrpc_kv_choice.feature](./examples/grpc_netrpc_kv_choice.feature)      | `examples/grpc/*` - Full example flow |
| [x]     | [ ]      | [negotiated_protocol_version.feature](./examples/negotiated_protocol_version.feature) | `examples/negotiated/*` - Full example flow |
| [x]     | [ ]      | [grpc_app_interaction.feature](./grpc_client/grpc_app_interaction.feature)     | `grpc_client_test.go` - `TestGRPC_App` |
| [x]     | [ ]      | [grpc_bidirectional_ping.feature](./grpc_client/grpc_bidirectional_ping.feature) | `grpc_client_test.go` - `TestGRPCConn_BidirectionalPing` |
| [x]     | [ ]      | [grpc_ping_lifecycle.feature](./grpc_client/grpc_ping_lifecycle.feature)       | `grpc_client_test.go` - `TestGRPC_Ping` |
| [x]     | [ ]      | [grpc_reflection.feature](./grpc_client/grpc_reflection.feature)             | `grpc_client_test.go` - `TestGRPC_Reflection` |
| [x]     | [ ]      | [grpc_stream.feature](./grpc_client/grpc_stream.feature)                   | `grpc_client_test.go` - `TestGRPCC_Stream` |
| [x]     | [ ]      | [grpc_broker_operation.feature](./grpc_protocol/grpc_broker_operation.feature) | `grpc_broker.go` - `GRPCBroker`, `gRPCBrokerServer`, `gRPCBrokerClientImpl` |
| [x]     | [ ]      | [grpc_client_connection.feature](./grpc_protocol/grpc_client_connection.feature) | `grpc_client.go` - `newGRPCClient`, `GRPCClient` |
| [x]     | [ ]      | [grpc_controller_shutdown.feature](./grpc_protocol/grpc_controller_shutdown.feature) | `grpc_controller.go` - `grpcControllerServer.Shutdown` |
| [x]     | [ ]      | [grpc_server_initialization.feature](./grpc_protocol/grpc_server_initialization.feature) | `grpc_server.go` - `GRPCServer`, `Init` |
| [x]     | [ ]      | [grpc_stdio_streaming.feature](./grpc_protocol/grpc_stdio_streaming.feature)   | `grpc_stdio.go` - `grpcStdioServer`, `grpcStdioClient`, `copyChan` |
| [x]     | [ ]      | [server_handshake_protocol.feature](./handshake/server_handshake_protocol.feature) | `server.go` - Handshake logic in `Serve`, `protocolVersion` |
| [x]     | [ ]      | [additional_notes_about_command.feature](./internal/cmdrunner/additional_notes_about_command.feature) | `cmd_runner_test.go` - `TestAdditionalNotesAboutCommand`; `notes_unix.go`, `notes_windows.go` |
| [x]     | [ ]      | [cmd_reattach_logic.feature](./internal/cmdrunner/cmd_reattach_logic.feature) | `cmd_reattach.go` - `ReattachFunc`, `CmdAttachedRunner` |
| [x]     | [ ]      | [cmd_runner_lifecycle.feature](./internal/cmdrunner/cmd_runner_lifecycle.feature) | `cmd_runner.go` - `CmdRunner`, `NewCmdRunner` |
| [x]     | [ ]      | [identity_addr_translator.feature](./internal/cmdrunner/identity_addr_translator.feature) | `addr_translator.go` - `addrTranslator` |
| [x]     | [ ]      | [process_alive_posix.feature](./internal/cmdrunner/process_alive_posix.feature) | `process_posix.go` - `_pidAlive`     |
| [x]     | [ ]      | [process_alive_windows.feature](./internal/cmdrunner/process_alive_windows.feature) | `process_windows.go` - `_pidAlive`   |
| [x]     | [ ]      | [process_wait_generic.feature](./internal/cmdrunner/process_wait_generic.feature) | `process.go` - `pidWait`, `pidAlive`   |
| [x]     | [ ]      | [grpc_muxer_interactions.feature](./internal/grpcmux/grpc_muxer_interactions.feature) | `internal/grpcmux/*` - Muxer implementations |
| [x]     | [ ]      | [json_log_parsing.feature](./logging_utils/json_log_parsing.feature)         | `log_entry.go` - `parseJSON`, `flattenKVPairs` |
| [x]     | [ ]      | [netrpc_unsupported_plugin_compliance.feature](./plugin/netrpc_unsupported_plugin_compliance.feature) | `plugin_test.go` - `NetRPCUnsupportedPlugin` compliance |
| [x]     | [ ]      | [grpc_plugin_contract.feature](./plugin_contracts/grpc_plugin_contract.feature) | `plugin.go` - `GRPCPlugin` interface |
| [x]     | [ ]      | [netrpc_plugin_contract.feature](./plugin_contracts/netrpc_plugin_contract.feature) | `plugin.go` - `Plugin` interface     |
| [x]     | [ ]      | [netrpc_unsupported_behavior.feature](./plugin_contracts/netrpc_unsupported_behavior.feature) | `plugin.go` - `NetRPCUnsupportedPlugin` behavior |
| [x]     | [ ]      | [client_protocol_interface.feature](./protocol_contracts/client_protocol_interface.feature) | `protocol.go` - `ClientProtocol` interface |
| [x]     | [ ]      | [server_protocol_interface.feature](./protocol_contracts/server_protocol_interface.feature) | `protocol.go` - `ServerProtocol` interface |
| [x]     | [ ]      | [rpc_client_app_interaction.feature](./rpc_client/rpc_client_app_interaction.feature) | `rpc_client_test.go` - `TestClient_App` |
| [x]     | [ ]      | [rpc_client_sync_streams.feature](./rpc_client/rpc_client_sync_streams.feature) | `rpc_client_test.go` - `TestClient_syncStreams` |
| [x]     | [ ]      | [mux_broker_operation.feature](./rpc_protocol/mux_broker_operation.feature)  | `mux_broker.go` - `MuxBroker`        |
| [x]     | [ ]      | [rpc_client_connection_management.feature](./rpc_protocol/rpc_client_connection_management.feature) | `rpc_client.go` - `RPCClient`, `newRPCClient` |
| [x]     | [ ]      | [rpc_server_connection_handling.feature](./rpc_protocol/rpc_server_connection_handling.feature) | `rpc_server.go` - `RPCServer`        |
| [x]     | [ ]      | [runner_interface_contracts.feature](./runner_contracts/runner_interface_contracts.feature) | `runner/runner.go` - Interfaces      |
| [x]     | [ ]      | [protocol_selection_logic.feature](./server/protocol_selection_logic.feature) | `server_test.go` - `TestProtocolSelection_no_server` (`protocolVersion` from `server.go`) |
| [x]     | [ ]      | [rm_listener_functionality.feature](./server/rm_listener_functionality.feature) | `server_test.go` - `TestRmListener`  |
| [x]     | [ ]      | [rm_listener_implementation.feature](./server/rm_listener_implementation.feature) | `server_test.go` - `TestRmListener_impl` |
| [x]     | [ ]      | [server_stdio_signal_handling.feature](./server/server_stdio_signal_handling.feature) | `server.go` - Stdio/Signal logic in `Serve` |
| [x]     | [ ]      | [server_stdlib_log_capture.feature](./server/server_stdlib_log_capture.feature) | `server_test.go` - `TestServer_testStdLogger` |
| [x]     | [ ]      | [server_test_mode_automtls_grpc.feature](./server/server_test_mode_automtls_grpc.feature) | `server_test.go` - `TestServer_testMode_AutoMTLS` |
| [x]     | [ ]      | [server_test_mode_grpc.feature](./server/server_test_mode_grpc.feature)    | `server_test.go` - `TestServer_testMode` |
| [x]     | [ ]      | [server_test_mode_netrpc.feature](./server/server_test_mode_netrpc.feature)  | `server_test.go` - `TestServer_RPC`    |
| [x]     | [ ]      | [server_unix_socket_directory.feature](./server/server_unix_socket_directory.feature) | `server_test.go` - `TestUnixSocketDir` |
| [x]     | [ ]      | [serve_mux_dispatch.feature](./server_dispatch/serve_mux_dispatch.feature)   | `server_mux.go` - `ServeMux`         |
| [x]     | [ ]      | [tcp_listener_creation.feature](./server_listeners/tcp_listener_creation.feature) | `server.go` - `serverListener_tcp`   |
| [x]     | [ ]      | [unix_listener_creation.feature](./server_listeners/unix_listener_creation.feature) | `server.go` - `serverListener_unix`  |
| [x]     | [ ]      | [server_unix_socket_permissions.feature](./server_unix/server_unix_socket_permissions.feature) | `server_unix_test.go` - `TestUnixSocketGroupPermissions` |
| [x]     | [ ]      | [set_group_writable.feature](./server_unix/set_group_writable.feature)       | `server.go` - `setGroupWritable`     |
| [x]     | [ ]      | [copy_stream_utility.feature](./stream_utils/copy_stream_utility.feature)    | `stream.go` - `copyStream`           |

```

This Markdown content will be saved to `features/review_checklist.md`.
