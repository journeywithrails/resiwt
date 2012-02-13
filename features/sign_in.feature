@sign_in
Feature: Sign in

  Scenario: Sign in as a free account user
    Given I am logged in
    When I go to the app homepage
    Then I should see "My Twitter accounts"
    And I should see "Add a Twitter Account"
    And I should see "Edit my Profile"
    
  Scenario: Sign in with a pro account user
    Given I am logged in with a pro account
    When I go to the app homepage
    Then I should see "My Twitter accounts"
    And I should see "Add a Twitter Account"
    And I should see "Edit my Profile"




  
