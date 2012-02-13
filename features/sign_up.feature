@sign_up
Feature: Sign up
  In order to allow users to sign up to user the site
  As an end user
  I want to capture the users detail and create a new account

  Scenario: Allow user to sign up using the details from beta invitation
    Given a app_invitation exists with recipient_email: "newuser@tweasier.com"
    And I go to the beta sign up page for "newuser@tweasier.com"
    Then I should see "Sign up to Tweasier"
    And the "user_email" field should contain "newuser@tweasier.com"
    When I fill in the following:
      | user_password              | password |
      | user_password_confirmation | password |

    And I choose "plan_free"
    And I press "Sign up"
    Then I should be on the sign in page
    And I should see "You will receive an email within the next few minutes"
    And 1 email should be delivered to newuser@tweasier.com
    #When I follow "Confirm mt email address" in the last email
    When I go to the confirmation url for "newuser@tweasier.com"
    Then I should see "Confirmed email and signed in."
    #Then I should be signed in as "newuser@tweasier.com"
    #And I should be on the app homepage