require 'spec_helper'

describe UsersController do
  describe "POST 'address'" do
    let(:params) { {"line1"=>"631 San Bruno Ave",
                    "city"=>"San Francisco", 
                    "state"=>"CA", "zip"=>"94107", 
                    "commit"=>"Save this information"} }
    context "with a signed in user" do
      login_user
      it "saves the address in the current user object" do
        post 'address', params
        User.find(@user.id).address.city.should eq "San Francisco"
      end
      it "redirects to the home page" do
        post 'address', params
        response.should redirect_to root_path
      end
      it "sets the notice flash" do
        post 'address', params
        flash[:notice].should_not be_nil
      end
    end
    context "without a signed in user" do
      it "redirects to signin page" do
        post 'address', params
        response.should redirect_to new_user_session_path
      end
      it "sets the error flash" do
        post 'address', params
        flash[:error].should_not be_nil
      end
    end
  end
end
