# Source: error_test.go - TestBasicError_ImplementsError
Feature: BasicError Type Compliance

  Scenario: BasicError can be used as a standard error
    Given a variable of type error
    When a new BasicError is created
    Then the BasicError instance should be assignable to the error variable
    # This scenario reflects a compile-time check in Go.
    # In a BDD context, this means that functions expecting an `error`
    # should be able to accept a `BasicError`.
