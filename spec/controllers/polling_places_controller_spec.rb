require 'spec_helper'

describe PollingPlacesController do

  describe "GET 'find'" do
    let (:address) { "1263 Pacific Ave. Kansas City KS" }
    it "returns http success" do
      get 'find', address: address
      response.should be_success
    end
    it "asks the VoterInfo model to look up the address" do
      VoterInfo.should_receive(:lookup).with(address)
      get 'find', address: address
    end

    it "renders the find view" do
      get 'find', address: address
      response.should render_template("find")
    end
    it "passes a PollingPlace object" do
      get 'find', address: address
      assigns[:voter_info].should be_a(VoterInfo)
    end
  end

end
