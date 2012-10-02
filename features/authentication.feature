Feature: Authentication

  So that I can provide my comments
  As a voter
  I want to become a registered user of the site

  @wip
  Scenario: Become a registered user
    Given that I am on the home page
    And I fill in "user_email" with "voter@example.org"
    And I fill in "user_password" with "voter123"
    And I fill in "user_password_confirmation" with "voter123"
    And I click the "Sign up" button
    Then I should see "Welcome! You have signed up successfully."
