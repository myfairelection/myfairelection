require 'spec_helper'

describe VoterInfoController do

  describe "GET 'find'" do
    context "with a valid address" do
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
      it "passes a VoterInfo object to the view" do
        get 'find', address: address
        assigns[:voter_info].should be_a(VoterInfo)
      end
    end
    context "with an empty address" do
      let (:address) { "" }
      it "returns http success" do
        get 'find', address: address
        response.should be_success
      end
      it "sets the error flash" do
        get 'find', address: address
        flash[:error].should_not be_nil
      end
      it "redirects to the home page" do
        get 'find', address: address
        response.should redirect_to(root_path)
      end
      it "does not pass a VoterInfo object to the view" do
        get 'find', address: address
        assigns.keys.should_not be_include(:voter_info)
      end
    end
  end
end
