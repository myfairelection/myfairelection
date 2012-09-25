Given /^that I am on the home page$/ do
  visit "/"
end

Then /^I should see "([^"]*)"$/ do |content|
  expect(page).to have_content(content)
end

Given /^I fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

Given /^I click the "([^"]*)" button$/ do |button|
  click_button(button)
end

