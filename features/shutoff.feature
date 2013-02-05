Feature: Shutoff

  So we can declare victory
  As an admin
  I want to put the site in shutoff mode

  Scenario: Thank you message on front page
    Given the site is in shutoff mode
    When I visit the "/" page
    Then I should see "Thanks to everyone who contributed"

  Scenario: No review link on polling place page
    Given the site is in shutoff mode
    And there is a polling location
    And I am a registered user
    And I log in
    When I visit the polling location page
    Then I should not see "Give Feedback"
