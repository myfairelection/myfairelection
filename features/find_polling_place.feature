Feature: Find My Polling Place

  So that I can vote
  As a voter
  I want to see the location and hours of my polling place

  Scenario: View home page
    When I am on the home page
    Then I should see "Where To Go To Vote"

  Scenario: Look up polling place with hours
    Given the Google API is stubbed to return "ks_response.json"
    When I am on the home page
    And I fill in "address" with "1263 Pacific Ave. Kansas City KS"
    And I click the "Show" button
    Then I should see "National Guard Armory"
    And I should see "8:00am to 8:00pm"

  Scenario: Look up address with no polling place information
    Given the Google API is stubbed to return "white_house.json"
    When I am on the home page
    And I fill in "address" with "1600 Pennsylvania Avenue NW, Washington, DC 20500"
    And I click the "Show" button
    Then I should see "No information is available."
