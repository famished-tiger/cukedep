
@some @feature:foo @depends_on:bar @depends_on:qux
Feature: Check-in
  As a video rental employee
  I want to register return of rented videos
  So that other members can them too 


  Scenario: Registering return of rented video
    When I enter the credentials "it's me"
    When I register the return of "The world of Cucumber" from "John Doe"
    Then I should see the return confirmed
    
