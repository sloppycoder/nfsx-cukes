@smoke
Feature: Login and then logout
  
Scenario: Login as Regular User
Given I am ready to login
 When I login as "user" with password "user"
 Then I should see dashboard page
  And I should see "Hayashi San" on the screen
  And I should not see "no card information available" on the screen
 And wait a sec
 When I logout
 And wait a sec
 Then I should see login page

Scenario: Login as Admin User
Given I am ready to login
 When I login as "admin" with password "admin"
 Then I should see dashboard page
  And I should see "Hayashi San" on the screen
  And I should not see "no card information available" on the screen
 When I logout
 Then I should see login page
