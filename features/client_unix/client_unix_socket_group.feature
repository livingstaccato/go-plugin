# Source: client_unix_test.go - TestSetGroup
Feature: Client Unix Socket Group Configuration (non-Windows)

  Background:
    Given the current user's group ID (GID) and group name are determined
    And a base temporary directory "baseTempDir" is created

  Scenario: Unix socket directory has correct group ownership and permissions when group is specified by GID
    Given a helper process "mock"
    And a plugin client configured with "mock" process and UnixSocketConfig specifying group as current GID and TempDir as "baseTempDir"
    And the client uses a custom RunnerFunc to inspect the command and socket directory before full execution
    When the plugin client starts
    Then during the RunnerFunc execution:
      | Assertion                                                                | Expected                                              |
      | Unix socket temporary directory "tmpDir" should be inside "baseTempDir"  | true                                                  |
      | "tmpDir" permissions should be 0o770                                     | true                                                  |
      | "tmpDir" group ID should match the current user's GID                    | true                                                  |
      | Plugin command environment should contain EnvUnixSocketDir set to "tmpDir" | true                                                  |
      | Plugin command environment should contain EnvUnixSocketGroup set to current GID | true                                                  |
    And the client startup should complete without errors
    And the plugin client is subsequently killed

  Scenario: Unix socket directory has correct group ownership and permissions when group is specified by name
    Given a helper process "mock"
    And a plugin client configured with "mock" process and UnixSocketConfig specifying group as current group name and TempDir as "baseTempDir"
    And the client uses a custom RunnerFunc to inspect the command and socket directory before full execution
    When the plugin client starts
    Then during the RunnerFunc execution:
      | Assertion                                                                | Expected                                                  |
      | Unix socket temporary directory "tmpDir" should be inside "baseTempDir"  | true                                                      |
      | "tmpDir" permissions should be 0o770                                     | true                                                      |
      | "tmpDir" group ID should match the current user's GID                    | true                                                      |
      | Plugin command environment should contain EnvUnixSocketDir set to "tmpDir" | true                                                      |
      | Plugin command environment should contain EnvUnixSocketGroup set to current group name | true                                                  |
    And the client startup should complete without errors
    And the plugin client is subsequently killed
