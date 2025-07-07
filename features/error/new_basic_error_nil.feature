# Source: error_test.go - TestNewBasicError_nil
Feature: BasicError Creation with Nil

  Scenario: Creating a BasicError with a nil input results in a nil error
    Given a nil error value
    When NewBasicError is called with the nil value
    Then the result should be nil
