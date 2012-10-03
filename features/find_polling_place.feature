Feature: Find My Polling Place

  So that I can vote
  As a voter
  I want to see the location and hours of my polling place

  Scenario: View home page
    Given I am on the home page
    Then I should see "Where To Go To Vote"

  Scenario: Look up polling place
    Given I am on the home page
    And I fill in "address" with "1263 Pacific Ave. Kansas City KS"
    And I click the "Show" button
    Then I should see "National Guard Armory"

  Scenario: Look up address with no polling place information
    Given I am on the home page
    And I fill in "address" with "631 San Bruno Ave, SF, CA"
    And I click the "Show" button
    Then I should see "No information is available."
