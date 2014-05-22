Given (/^I am a registered user$/) do
  @user = FactoryGirl.create(:user)
end

Given (/^I am a registered admin user$/) do
  @user = FactoryGirl.create(:admin)
end

Given (/^I am a registered user with email "([^"]*)" and password "([^"]*)"$/) do |email, password|
  @user = FactoryGirl.create(:user, email: email, password: password)
end

Given (/^I am a registered user with the address "([^\"]*)"$/) do |arg1|
  step 'I am a registered user'
  @user.address = Address.new('line1' => '1263 Pacific Avenue',
                              'city' =>'Kansas City',
                              'state' => 'KS',
                              'zip' => '66102')
  @user.save
end

Given (/^I am a confirmed user with email "([^"]*)" and password "([^"]*)"$/) do |email, password|
  step "I am a registered user with email \"#{email}\" and password \"#{password}\""
  @user.confirmed_at = Time.now
  @user.save
end


Given (/^I am not logged in$/) do
  # nothing to do here
end

Given (/^I log in$/) do
  visit '/'
  step "I fill in \"user_email\" in the form \"signin\" with \"#{@user.email}\""
  step "I fill in \"user_password\" in the form \"signin\" with \"#{@user.password}\""
  step 'I click the "Log In" button in the form "signin"'
end


Given (/^I am on the home page$/) do
  visit '/'
end

Given (/^there is a feed with the url "([^"]*)"$/) do |url|
  Feed.create!(url: url)
end

Given (/^there is a polling location$/) do
  @polling_location = FactoryGirl.create(:polling_location)
end

Given (/^the site is in shutoff mode$/) do
  Settings['shutoff'] = true
end

When (/^I am on the "([^"]*)" page$/) do |path|
  visit path
end

When (/^I visit the "([^"]*)" page$/) do |path|
  visit path
end

When (/^I visit the polling location page$/) do
  visit "/polling_locations/#{@polling_location.id}"
end

When (/^I fill in "([^"]*)" in the form "([^"]*)" with "([^"]*)"$/) do |field, form, value|
  within("form\##{form}") do
    fill_in(field, with: value)
  end
end

When (/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When (/^I click the "([^"]*)" button$/) do |button|
  click_button(button)
end

When (/^I click the "([^"]*)" button in the form "([^"]*)"$/) do |button, form|
  within("form\##{form}") do
    click_button(button)
  end
end

When (/^I follow "([^"]*)"$/) do |link|
  click_link(link)
end

When (/^I follow the first "([^"]*)" link$/) do |link|
  first(:link, link).click
end

When (/^I register as a new user$/) do
  step 'I visit the "/users/sign_up" page'
  step 'I fill in "user_email" in the form "new_user" with "voter@example.org"'
  step 'I fill in "user_password" in the form "new_user" with "voter123"'
  step 'I fill in "user_password_confirmation" in the form "new_user" with "voter123"'
  step 'I click the "Register" button in the form "new_user"'
end

When (/^I click on the link in the email$/) do
  pending # express the regexp above with the code you wish you had
end

When (/^I run "([^"]*)"$/) do |command|
  system command
end

When (/^I save and open the page$/) do
  puts current_path
  save_and_open_page
end

Then (/^I should see "([^"]*)"$/) do |content|
  expect(page).to have_content(content)
end

Then (/^I should not see "([^"]*)"$/) do |content|
  expect(page).to_not have_content(content)
end

Then (/^I should see a button named "([^"]*)"$/) do |button|
  expect(page).to have_button(button)
end

Then (/^there should be "([^"]*)" "([^"]*)" objects in the database$/) do |n, klass|
  Kernel.const_get(klass).count.should == n.to_i
end
