require 'spec_helper'

describe VoterInfoController do

  describe "GET 'find'" do
    context "with a valid address" do
      before(:each) do
        RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/ks_response.json").read)
      end
      let (:address) { "1263 Pacific Ave. Kansas City KS" }
      it "returns http success" do
        get 'find', address: address
        response.should be_success
      end
      it "asks the VoterInfo model to look up the address" do
        VoterInfo.should_receive(:lookup, &VoterInfo.method(:lookup)).with(address)
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
      it "logs a lookup event" do
        get 'find', address: address
        session[:events].should be_include({category: "VoterInfo", action: "Find", label: "success"})
      end
    end
    context "with a valid address with no polling locations found" do
      before(:each) do
        RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/white_house.json").read)
      end
      let (:address) { "1600 Pennsylvania Avenue NW, Washington, DC 20500" }
      it "returns http success" do
        get 'find', address: address
        response.should be_success
      end
      it "asks the VoterInfo model to look up the address" do
        VoterInfo.should_receive(:lookup, &VoterInfo.method(:lookup)).with(address)
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
      it "logs a lookup event" do
        get 'find', address: address
        session[:events].should be_include({category: "VoterInfo", action: "Find", label: "noStreetSegmentFound"})
      end
    end
    context "with an empty address" do
      before(:each) do  
        RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/no_address.json").read)
      end
      let (:address) { "" }
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
      it "logs a lookup event" do
        get 'find', address: address
        session[:events].should be_include({category: "VoterInfo", action: "Find", label: "noAddressParameter"})
      end
    end
    context "with an unparseable address" do
      before(:each) do
        RestClient.stub(:post).and_return(File.open("spec/fixtures/voter_info_responses/unparseable_address.json").read)
      end
      let (:address) { "" }
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
      it "logs a lookup event" do
        get 'find', address: address
        session[:events].should be_include({category: "VoterInfo", action: "Find", label: "addressUnparseable"})
      end
    end
  end
end
