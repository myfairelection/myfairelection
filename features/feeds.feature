Feature: Manage Feeds
  
  So that I can keep the list of polling places current
  As an administrator
  I want to manage the available feeds

  Scenario: Load a feed from the CLI
    When I run "rails runner 'Feed.load_from_file' spec/fixtures/test_feeds/sample_feed_for_v4.0.xml" 
    Then there should be "6" "PollingLocation" objects in the database
    And there should be "1" "Feed" objects in the database                                 
