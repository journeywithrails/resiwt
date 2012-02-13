Given /^I am logged in$/ do
  
  @current_user = User.make
  @current_user.confirm_email!

  visit "/sign_in" 
  fill_in("session_email", :with => @current_user.email) 
  fill_in("session_password", :with => 'password') 
  click_button("Sign in")
  
  if page.respond_to? :should
    page.should have_content('Signed in')
  else
    assert page.has_content?('Signed in')
  end
end

Given /^I am logged in with a pro account$/ do
  
  @current_user = User.make(:paid)
  @current_user.confirm_email!

  visit "/sign_in" 
  fill_in("session_email", :with => @current_user.email) 
  fill_in("session_password", :with => 'password') 
  click_button("Sign in")
  
  if page.respond_to? :should
    page.should have_content('Signed in')
  else
    assert page.has_content?('Signed in')
  end
end

Then /^I should be signed in as "([^"]*)"$/ do |email|
  @current_user.email.should == email
end