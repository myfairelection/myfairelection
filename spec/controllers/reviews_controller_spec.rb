require 'spec_helper'

describe ReviewsController do
  let(:polling_location) { FactoryGirl.create(:polling_location) }
  describe 'POST create' do
    let(:params) { 
      { "review" => 
        { "voted_at" => "2012-11-06 16:35",
          "wait_time" => "15",
          "able_to_vote" => true,
          "rating" => 4,
          "comments" => "This polling place smelled of cheese."
        },
        "polling_location_id" => polling_location.to_param
      }
    }
    context 'with a signed in user' do
      login_user
      it "creates a new review object" do
        expect {post 'create', params}.to change{Review.count}.by(1)
      end
      it "redirects to the location page" do
        post 'create', params
        response.should redirect_to polling_location_path(polling_location)
      end
    end
  end
  describe 'GET new' do
    let(:params) { { "polling_location_id" => polling_location.to_param} }
    context "with a logged in user" do
      login_user
      before(:each) do
        get 'new', params 
      end
      it "renders the new template" do
        expect(response).to render_template('reviews/new')
      end
      it "passes a new review" do
        expect(assigns[:review]).to be_new_record
      end
      it "has set the polling_location field already" do
        expect(assigns[:review].polling_location).to eq polling_location
      end
      it "has the user field set already" do
        expect(assigns[:review].user).to eq @user
      end
    end
  end
end