Feature: Review a Polling Location

  So that I can help America
  As a voter
  I want to give feedback about my voting experience

  @wip
  Scenario: Navigate to the review form
    Given I am a registered user with the address "1263 Pacific Ave. Kansas City KS"
    And the Google API is stubbed to return "ks_response.json"
    And I log in
    And I am on the home page
    And I follow "Give Feedback"
    Then I should see "When did you arrive to vote?"

  @wip
  Scenario: Election day workflow with new user
    Given the Google API is stubbed to return "ks_response.json"
    When I am on the home page
    And I fill in "address" with "1263 Pacific Ave. Kansas City KS"
    And I click the "Show" button
    And I should see "National Guard Armory"
    And I follow "Give Feedback"
    And I should see "Please Register First"
    And I fill in "user_email" in the form "new_user" with "voter@example.org"
    And I fill in "user_password" in the form "new_user" with "voter123"
    And I fill in "user_password_confirmation" in the form "new_user" with "voter123"
    And I click the "Register" button in the form "new_user"
    And I should see "Giving feedback for:"

  @wip
  Scenario: Election day workflow with existing user
    Given I am a registered user with email "voter@example.org" and password "foobar"
    And the Google API is stubbed to return "ks_response.json"
    When I am on the home page
    And I fill in "address" with "1263 Pacific Ave. Kansas City KS"
    And I click the "Show" button
    And I should see "National Guard Armory"
    And I follow "Give Feedback"
    And I should see "Please Register First"
    And I fill in "user_email" in the form "signin" with "voter@example.org"
    And I fill in "user_password" in the form "signin" with "foobar"
    And I click the "Log In" button in the form "signin"
    And I should see "Giving feedback for:"

  @wip
  Scenario: Review a polling location other than what's found
    Given I am a registered user
    And the Google API is stubbed to return "ks_response.json"
    And I log in
    When I am on the home page
    And I fill in "address" with "631 San Bruno Ave, SF, CA"
    And I click the "Show" button
    And I follow "My polling location is not listed"
    And I fill in "polling_location_description" with "I voted in a food truck on Folsom and 22nd"
    And I click the "Give Feedback" button
    Then I should see "Giving feedback for:"
