Feature: Find My Polling Place

  So that I can vote
  As a voter
  I want to see the location and hours of my polling place

  Scenario: View home page
    When I am on the home page
    Then I should see "Start by entering your address so we can find where you voted."

  Scenario: Look up polling place with hours and early voting
    Given the Google API is stubbed to return "ks_response.json"
    When I am on the home page
    And I fill in "address" with "1263 Pacific Ave. Kansas City KS"
    And I click the "Show" button
    Then I should see "National Guard Armory"
    And I should see "Kansas City Ballot Center"

  Scenario: Look up address with no polling place information
    Given the Google API is stubbed to return "white_house.json"
    When I am on the home page
    And I fill in "address" with "1600 Pennsylvania Avenue NW, Washington, DC 20500"
    And I click the "Show" button
    Then I should see "My polling location is not listed"

  Scenario: Look up empty string
    Given the Google API is stubbed to return "no_address.json"
    When I am on the home page
    And I fill in "address" with ""
    And I click the "Show" button
    Then I should see "Please enter an address."

  Scenario: Look up garbage string
    Given the Google API is stubbed to return "unparseable_address.json"
    When I am on the home page
    And I fill in "address" with "safasdfasdasdf"
    And I click the "Show" button
    Then I should see "Could not figure out your address. Please check the address you gave us."

  Scenario: Log in with no saved address
    Given I am a registered user
    And I log in
    When I am on the home page
    Then I should see "Start by entering your address so we can find where you voted."
 
  Scenario: See saved polling place info
    Given I am a registered user with the address "1263 Pacific Ave. Kansas City KS"
    And the Google API is stubbed to return "ks_response.json"
    And I log in
    When I am on the home page
    Then I should see "Your current voting information"
    And I should see "National Guard Armory"
    And I should see "Kansas City Ballot Center"
