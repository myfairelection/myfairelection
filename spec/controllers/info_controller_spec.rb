require 'spec_helper'

describe InfoController do

  %w(contact_us credits fraud privacy_policy terms_of_use).each do |page|
    it "renders the #{page} template" do
      get page
      response.should render_template("info/#{page}")
    end
  end
  
end
