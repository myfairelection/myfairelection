require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    it "passes a new review" do
      get 'index'
      expect(assigns[:review]).to be_new_record
    end
    context 'with a signed in user' do
      login_user
      it "sets the user object" do
      get 'index'
        expect(assigns[:review].user).to eq @user
      end
    end
  end

end
