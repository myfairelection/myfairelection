Feature: Authentication

  So that I can provide my comments
  As a voter
  I want to become a registered user of the site

  Scenario: Become a registered user
    Given I am not logged in 
    When I register as a new user
    Then I should see "Welcome! You have signed up successfully."
    And "voter@example.org" should receive an email with subject "Confirmation instructions"

  Scenario: Log in as a user
    Given I am a registered user with email "voter@example.org" and password "foobar"
    When I am on the home page
    And I fill in "user_email" in the form "signin" with "voter@example.org"
    And I fill in "user_password" in the form "signin" with "foobar"
    And I click the "Log In" button in the form "signin"
    Then I should see "Signed in successfully."

  @wip
  Scenario: Confirm my email address
    When I register as a new user
    And "voter@example.org" opens the email
    And they click the first link in the email
    Then I should see "Your account was successfully confirmed."
