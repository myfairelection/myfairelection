Feature: Review a Polling Location

  So that I can help America
  As a voter
  I want to give feedback about my voting experience

  Scenario: Navigate to the review form
    Given I am a registered user with the address "1263 Pacific Ave. Kansas City KS"
    And the Google API is stubbed to return "ks_response.json"
    And I log in
    And I am on the home page
    And I follow "Give Feedback"
    Then I should see "When did you arrive to vote?"
