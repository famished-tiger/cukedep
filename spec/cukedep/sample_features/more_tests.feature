# Notice how we specify the identifier of this feature file (quux)
@more @feature:quux
Feature: Subscribing member
  As a video rental owner
  I want to register future customers 
  So I can rent videos to authorized people 
  
  Scenario: Start with an empty membership
    Given there is no member yet
    Then I should see member "John Doe" as unknown
  

  Scenario Outline: Adding videos to the catalogue
    Given I subscribe "<name>"
    Then I should see member "<name>" as registered
  
  Examples:
  |name|
  |John Doe|
  |Jed Eye|
  |Bill Bo|
  |Jack Orjones|
  |Mary Gherkin|
  |Waldo Cuke|
