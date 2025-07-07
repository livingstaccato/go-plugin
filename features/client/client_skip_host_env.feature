# Source: client_test.go - TestClient_SkipHostEnv
Feature: Client Host Environment Variable Handling

  Scenario: Client skips passing host environment variables to plugin when SkipHostEnv is true
    Given the host environment variable "PLUGIN_TEST_SKIP_HOST_ENV" is set to "foo"
    And a helper process "test-skip-host-env-true" that expects "PLUGIN_TEST_SKIP_HOST_ENV" to be unset for success
    And a plugin client configured with this process and "SkipHostEnv" set to true
    When the plugin client is started
    And the client is allowed to run until it exits
    Then the helper process should have exited successfully

  Scenario: Client passes host environment variables to plugin when SkipHostEnv is false
    Given the host environment variable "PLUGIN_TEST_SKIP_HOST_ENV" is set to "foo"
    And a helper process "test-skip-host-env-false" that expects "PLUGIN_TEST_SKIP_HOST_ENV" to be set for success
    And a plugin client configured with this process and "SkipHostEnv" set to false
    When the plugin client is started
    And the client is allowed to run until it exits
    Then the helper process should have exited successfully
