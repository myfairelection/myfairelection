require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    let(:polling_location) { FactoryGirl.create(:polling_location) }
    let(:params) { 
      { "review" => 
        { "voted_at" => "2012-11-06 16:35",
          "wait_time" => "15",
          "able_to_vote" => true,
          "rating" => 4,
          "comments" => "This polling place smelled of cheese.",
          "polling_location_id" => polling_location.id.to_s
        }
      }
    }
    context 'with a signed in user' do
      login_user
      it "creates a new review object" do
        expect {post 'create', params}.to change{Review.count}.by(1)
      end
      it "redirects back to the voter info page" do
        post 'create', params
        response.should redirect_to voter_info_path
      end

      # it "adds the current user Id" do
      #   Review.new.should_receive(params["review"].merge({"user_id" => @user.id.to_s}))
      # end
    end
  end
end