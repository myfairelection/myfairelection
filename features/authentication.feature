Feature: Authentication

  So that I can provide my comments
  As a voter
  I want to become a registered user of the site

  Scenario: Become a registered user
    Given I am not logged in 
    When I am on the home page
    And I fill in "user_email" in the form "new_user" with "voter@example.org"
    And I fill in "user_password" in the form "new_user" with "voter123"
    And I fill in "user_password_confirmation" in the form "new_user" with "voter123"
    And I click the "Sign up" button in the form "new_user"
    Then I should see "Welcome! You have signed up successfully."
    And I should see "A message with a confirmation link has been sent to your email address."
    And "voter@example.org" should receive an email with subject "Confirmation instructions"

  Scenario: Log in as a user
    Given I am a registered user with email "voter@example.org" and password "foobar"
    When I am on the home page
    And I fill in "user_email" in the form "signin" with "voter@example.org"
    And I fill in "user_password" in the form "signin" with "foobar"
    And I click the "Sign In" button in the form "signin"
    Then I should see "Signed in successfully."

