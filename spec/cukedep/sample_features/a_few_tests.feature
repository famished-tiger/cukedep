
@a_few @feature:qux
Feature: Registering user credentials
  As a video rental employee
  I want to enter my credentials
  So I can identify myself when use the rental application

  Scenario: Start without credentials
    Given there is no registered user
    When I enter the credentials "it's me"
    Then I should not be authorized


  Scenario Outline: Registering some credentials
    When I register my credentials "<credentials>"
    When I enter the credentials "<credentials>"
    Then I should see a welcome message
  
  Examples:
  |credentials|
  |it's me|
  |himself|
  |nemo|

