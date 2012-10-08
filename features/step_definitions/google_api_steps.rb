Given /^the Google API is stubbed to return "([^"]*)"$/ do |fixture_name|
  RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/#{fixture_name}").read)
end
