# Source: internal/cmdrunner/cmd_runner_test.go - TestAdditionalNotesAboutCommand
Feature: Additional Notes About Command Executable

  Background:
    Given the testdata executables are present (requires 'make' in 'testdata/' directory)

  Scenario Outline: Correct diagnostic notes are generated for different executable types
    Given the executable file "<ExecutableFile>" located in "testdata/"
    When the function "additionalNotesAboutCommand" is called with the path to this executable
    Then the generated notes should contain "<ExpectedNoteSubstring>"

    Examples:
      | ExecutableFile      | ExpectedNoteSubstring | Notes                                        |
      | windows-amd64.exe   | PE                    | Windows Portable Executable                  |
      | windows-amd64.exe   | amd64                 | AMD64 Architecture (could be PE specific)    |
      | windows-386.exe     | PE                    | Windows Portable Executable                  |
      | windows-386.exe     | 386                   | 386 Architecture (could be PE specific)      |
      | linux-amd64         | ELF                   | Linux Executable and Linkable Format         |
      | linux-amd64         | amd64                 | AMD64 Architecture (could be ELF specific)   |
      | darwin-amd64        | MachO                 | macOS Mach-O executable                      |
      | darwin-amd64        | amd64                 | AMD64 Architecture (could be Mach-O specific)|
      | darwin-arm64        | MachO                 | macOS Mach-O executable                      |
      | darwin-arm64        | CpuArm64              | ARM64 Architecture (could be Mach-O specific)|

  # Note: The original test checks for multiple substrings for some architectures (e.g., amd64, EM_X86_64, CpuAmd64).
  # The Gherkin examples simplify this to one defining characteristic per row for clarity,
  # but the underlying implementation would need to satisfy all original checks.
  # For example, for "linux-amd64", notes should contain "ELF" AND something like "amd64".
  # This might be better handled by having multiple "Then the notes should contain X" steps per example,
  # or a more complex table if the Gherkin runner supports it easily.
  # For now, this structure captures the essence.
