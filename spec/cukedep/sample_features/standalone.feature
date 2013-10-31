# § <- This character is UTF-8
# This feature has no identifier and no explicit dependencies
Feature: Registering new videos
  As a video rental owner
  I want to add more videos to my catalogue
  So I can offer newer videos for rental
  
  Background:
    Given the catalogue is empty
    
  Scenario: Start with an empty catalogue
    Then I should see the video "Othello" as unknown
    
    # Let's do something
    When I add the video "Othello" to the catalogue
    Then I should see the video "Othello" as available
    
    # Undo what we just did
    When I remove the video "Othello"
    Then I should see the video "Othello" as unknown
