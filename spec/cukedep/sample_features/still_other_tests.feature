# Notice how we specify the identifier of this feature file (baz)
@still_other @feature:baz
Feature: Registering new videos
  As a video rental owner
  I want to add more videos to my catalogue
  So I can offer newer videos for rental
  
  Scenario: Start with an empty catalogue
    Given the catalogue is empty
    Then I should see the video "The world of Cucumber" as unknown
  

  Scenario Outline: Adding videos to the catalogue
    Given I add the video "<title>" to the catalogue
    Then I should see the video "<title>" as available
  
  Examples:
  |title|
  | The world of Cucumber |
  | The empire of Cucumber |
  | The revenge of the Cucumber |
  | The peeled Cucumber |
  | The masked Cucumber|
  | Cucumber vs. Gherkin|
