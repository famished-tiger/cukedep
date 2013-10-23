
# Notice how dependencies between feature files are specified
@yet_other @feature:bar @depends_on:baz @depends_on:qux @depends_on:quux
Feature: Renting videos
  As a video rental employee
  I want to register rentals made by a member 
  So I can run my business

  Scenario Outline: Renting videos to a member 
    When I enter the credentials "it's me"
    When I register the rental of "<title>" for "John Doe"
    Then I should see the rental confirmed
    
  Examples:
  |title|
  |The world of Cucumber|
  |The masked Cucumber|
    
    
