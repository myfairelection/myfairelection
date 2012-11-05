Feature: Admin

  So that I can tell what's going on
  As an admin
  I want to see status

  Scenario: Can't get there without logging in
    Given I am not logged in
    When I visit the "/admin" page
    Then I should see "You need to sign in or sign up before continuing."

  Scenario: Can't get there as normal user
    Given I am a registered user with email "voter@example.org" and password "foobar"
    When I log in
    And I visit the "/admin" page
    Then I should see "Permission denied"

  Scenario: Can get there as an admin
    Given I am a registered admin user
    When I log in
    And I visit the "/admin" page
    Then I should see "Current Status"
