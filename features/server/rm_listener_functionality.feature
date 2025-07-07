# Source: server_test.go - TestRmListener
Feature: rmListener Functionality

  Scenario: rmListener deletes the associated file upon closing
    Given a TCP listener "tcp_listener" is started on "127.0.0.1:0"
    And a temporary file "temp_file" is created
    And an rmListener "deleting_listener" is created, wrapping "tcp_listener" and associated with "temp_file" path
    When "deleting_listener" is closed
    Then the close operation should succeed
    And "temp_file" should no longer exist
