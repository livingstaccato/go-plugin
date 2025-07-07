# Source: discover.go - Discover function
Feature: Plugin Discovery Mechanism

  Background:
    The `Discover` function is used to find plugin executables in a directory based on a glob pattern.
    Its behavior, particularly regarding path resolution and globbing, needs to be consistent for cross-platform porting.
    These scenarios assume a mock filesystem setup.

  Scenario: Discover finds plugins matching a simple glob in a relative directory
    Given a directory "plugins_dir" relative to the current working directory
    And "plugins_dir" contains files: "my-plugin-v1", "my-plugin-v2", "other-file"
    When `Discover("my-plugin-*", "plugins_dir")` is called
    Then the result should be a list containing the absolute paths to "plugins_dir/my-plugin-v1" and "plugins_dir/my-plugin-v2"
    And no error should occur

  Scenario: Discover finds plugins matching a simple glob in an absolute directory
    Given an absolute directory "/opt/plugins"
    And "/opt/plugins" contains files: "my-plugin-v1.exe", "my-plugin-v2.exe", "readme.txt"
    When `Discover("my-plugin-*.exe", "/opt/plugins")` is called
    Then the result should be a list containing "/opt/plugins/my-plugin-v1.exe" and "/opt/plugins/my-plugin-v2.exe"
    And no error should occur

  Scenario: Discover handles dot directory "." correctly
    Given the current working directory contains files: "pluginA-0.1", "pluginB-0.2", "script.sh"
    When `Discover("plugin*-*", ".")` is called
    Then the result should be a list containing the absolute paths to "./pluginA-0.1" and "./pluginB-0.2"

  Scenario: Discover returns an empty list if no files match the glob
    Given a directory "empty_plugins"
    And "empty_plugins" contains no files matching "specific-plugin-*"
    When `Discover("specific-plugin-*", "empty_plugins")` is called
    Then the result should be an empty list
    And no error should occur

  Scenario: Discover returns an empty list if the directory is empty
    Given an empty directory "truly_empty_dir"
    When `Discover("*", "truly_empty_dir")` is called
    Then the result should be an empty list
    And no error should occur

  Scenario: Discover handles errors from filepath.Abs if directory resolution fails
    Given a directory path "invalid_dir_path" that `filepath.Abs` will fail to resolve (e.g., due to permissions or it's malformed beyond simple non-existence for Glob)
    When `Discover("*", "invalid_dir_path")` is called
    Then the result should be nil or an empty list
    And an error from `filepath.Abs` should be returned

  Scenario: Discover handles errors from filepath.Glob (e.g., bad pattern)
    Given a directory "some_dir"
    And a syntactically invalid glob pattern (e.g., "[")
    When `Discover("[", "some_dir")` is called
    Then the result should be nil or an empty list
    And an error from `filepath.Glob` (e.g., ErrBadPattern) should be returned

  Scenario Outline: Discover respects platform path and globbing conventions (Conceptual)
    Given a directory structure on <OS> with files <Files>
    And the `Discover` function is called with glob "<Glob>" and directory "<Directory>"
    Then the discovered files should be <ExpectedDiscoveredFiles> according to <OS> globbing rules (e.g. case sensitivity)

    Examples:
      | OS      | Directory | Files                                     | Glob        | ExpectedDiscoveredFiles                     | Notes                               |
      | Linux   | ./plugins | ["MyPlugin", "myplugin", "MYPLUGIN.SO"] | "myplugin"  | ["./plugins/myplugin"]                      | Case-sensitive glob                 |
      | Windows | C:\\plugins | ["MyPlugin.exe", "myplugin.exe"]        | "myplugin*" | ["C:\\plugins\\MyPlugin.exe", "C:\\plugins\\myplugin.exe"] | Case-insensitive path, glob may vary |
      # This scenario highlights the need for the underlying filepath.Glob to behave correctly
      # for the target OS. The Go standard library aims to do this.
      # Testing this BDD would require simulating or running on different OS environments.

  # Future considerations mentioned in discover.go (TODO: test, smarter checks):
  # Scenario: Discover (Future) filters for executable files only
  #   Given a directory "exec_test" with files: "pluginX" (executable), "pluginY" (not executable)
  #   When `Discover("plugin*", "exec_test")` is called (assuming future executable check)
  #   Then the result should only contain the absolute path to "exec_test/pluginX"
