require 'spec_helper'

describe AdminController do
  describe 'GET index' do
    context "not logged in" do
      it "is not successful" do
        get 'index'
        response.should_not be_success
      end
    end
    context "logged in as a non admin" do
      login_user
      it "is not successful" do
        get 'index'
        response.should_not be_success
      end
    end
    context "logged in as an admin" do
      login_admin
      it "is successful" do
        get 'index'
        response.should be_success
      end
      it "renders the index tempalte" do
        get 'index'
        response.should render_template('admin/index')
      end
      it "passes a list of reviews" do
        get 'index'
        assigns[:reviews].should_not be_nil
      end
    end
  end
end
