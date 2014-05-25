require 'spec_helper'

describe InfoController, type: :controller do

  %w(contact_us credits fraud privacy_policy terms_of_use).each do |page|
    it "renders the #{page} template" do
      get page
      expect(response).to render_template("info/#{page}")
    end
  end

end
