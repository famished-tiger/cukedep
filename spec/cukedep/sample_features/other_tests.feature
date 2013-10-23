# Notice how dependencies between feature files are specified
@other @feature:corge @depends_on:foo
Feature: Deleting videos
  As a video rental employee
  I want to remove old/damaged videos 
  So I keep the quality of videos in the shelves

  Scenario Outline: Renting videos to a member 
    When I remove the video "<title>"
    Then I should see the video "<title>" as unknown
    
  Examples:
  |title|
  |The world of Cucumber|
  |Cucumber vs. Gherkin|