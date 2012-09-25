Feature: Find My Polling Place

  So that I can vote
  As a voter
  I want to see the location and hours of my polling place

  Scenario: View home page
    Given that I am on the home page
    Then I should see "Look up polling place"

  Scenario: Look up polling place
    Given that I am on the home page
    And I fill in "address" with "1263 Pacific Ave. Kansas City KS"
    And I click the "Lookup" button
    Then I should see "National Guard Armory"

