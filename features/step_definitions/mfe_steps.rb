Given /^that I am on the home page$/ do
  visit "/"
end

Then /^I should see "([^"]*)"$/ do |content|
  expect(page).to have_content(content)
end

Given /^I fill in "([^"]*)" in the form "([^"]*)" with "([^"]*)"$/ do |field, form, value|
  within("form\##{form}") do
    fill_in(field, with: value)
  end
end

Given /^I fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

Given /^I click the "([^"]*)" button$/ do |button|
  click_button(button)
end

Given /^I click the "([^"]*)" button in the form "([^"]*)"$/ do |button, form|
  within("form\##{form}") do
    click_button(button)
  end
end
