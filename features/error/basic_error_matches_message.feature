# Source: error_test.go - TestBasicError_MatchesMessage
Feature: BasicError Message Handling

  Scenario: BasicError preserves the original error message
    Given an original error with message "foo"
    When a new BasicError is created wrapping the original error
    Then the string representation of the BasicError should be "foo"
