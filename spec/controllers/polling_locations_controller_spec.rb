require 'spec_helper'

describe PollingLocationsController do

  let (:polling_location) { FactoryGirl.create(:polling_location)}
  describe "GET 'show'" do
    before (:each) do
      get 'show', :id => polling_location.to_param
    end

    it "returns http success" do
      expect(response).to be_success
    end
    it "renders the show template" do
      expect(response).to render_template "polling_locations/show"
    end
    it "passes the polling location to the view" do
      expect(assigns[:polling_location]).to eq polling_location
    end
  end

end
