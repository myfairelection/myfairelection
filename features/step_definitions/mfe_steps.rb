Given /^I am not logged in$/ do
  # nothing to do here
end

Given /^I am on the home page$/ do
  visit "/"
end

Given /^there is a "([^"]*)" user named "([^"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Given /^I have an account on "([^"]*)" named "([^"]*)"$/ do |provider, username|
  if provider == "twitter"
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'uid' => '827724',
      'provider' => 'twitter',
      'info' => { 'nickname' => username }
    })
  else
    pending "Cucumber: unknown auth provider #{provider}"
  end
end

When /^I fill in "([^"]*)" in the form "([^"]*)" with "([^"]*)"$/ do |field, form, value|
  within("form\##{form}") do
    fill_in(field, with: value)
  end
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^I click the "([^"]*)" button$/ do |button|
  click_button(button)
end

When /^I click the "([^"]*)" button in the form "([^"]*)"$/ do |button, form|
  within("form\##{form}") do
    click_button(button)
  end
end

When /^I follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^I should see "([^"]*)"$/ do |content|
  expect(page).to have_content(content)
end
