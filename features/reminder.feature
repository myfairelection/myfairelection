Feature: Reminder

  So that I can remember to vote
  As a registered user
  I want to ask to be reminded to vote

  Scenario: See reminder to confirm
    Given I am a registered user
    And I log in
    Then I should see "To be able to send you an email reminder to vote, we need you to confirm your email address."

  Scenario: Resend confirmation email
    Given I am a registered user with email "voter@example.org" and password "foobar"
    When I log in
    And I click the "Resend confirmation instructions" button
    Then I should see "You are already signed in"
    And "voter@example.org" should receive 2 emails with subject "Confirmation instructions"

  Scenario: Already confirmed
    Given I am a confirmed user with email "foo@bar.com" and password "foobar"
    When I log in
    Then I should see "On voting day, receive an reminder from us to vote and tell us how your polling place did."

  Scenario: Sign up for reminder
    Given I am a confirmed user with email "foo@bar.com" and password "foobar"
    When I log in
    And I click the "Remind Me" button 
    Then I should see "Thanks for signing up for a reminder to vote"
