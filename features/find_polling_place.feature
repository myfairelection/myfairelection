Feature: Find My Polling Place

  So that I can vote
  As a voter
  I want to see the location and hours of my polling place

  Scenario: View home page
    When I am on the home page
    Then I should see "Find out about your voting location"

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
    Then I should see "We could not find information for the address you provided."

  Scenario: Save polling place info
    Given I am a registered user
    And I log in
    And the Google API is stubbed to return "ks_response.json"
    When I am on the home page
    And I fill in "address" with "1263 Pacific Ave. Kansas City KS"
    And I click the "Show" button
    And I click the "Save this information" button
    Then I should see "Your address has been saved"

  Scenario: See saved polling place info
    Given I am a registered user with the address "1263 Pacific Ave. Kansas City KS"
    And the Google API is stubbed to return "ks_response.json"
    And I log in
    When I am on the home page
    Then I should see "Your current voting information"



