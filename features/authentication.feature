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

  Scenario: Sign in with Twitter
    Given I am not logged in 
    And I have an account on "twitter" named "test_user"
    When I am on the home page
    And I follow "Sign in with Twitter"
    Then I should see "@test_user"
  
  @wip
  Scenario: Second user from Twitter
    Given I am not logged in 
    And there is a "twitter" user named "test_user1"
    And I have an account on "twitter" named "test_user2"
    When I am on the home page
    And I follow "Sign in with Twitter"
    Then I should see "@test_user"
