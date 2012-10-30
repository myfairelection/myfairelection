require 'spec_helper'

describe ReviewsController do
  let(:polling_location) { FactoryGirl.create(:polling_location) }
  describe 'POST create' do
    let(:params) { 
      { "review" => 
        { "voted_day" => "11-06",
          "voted_time" => "13:45",
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
      it "sets the notice flash" do
        post 'create', params
        flash[:notice].should_not be_nil
      end
      it "passes the current user to the model" do
        Review.should_receive(:create!).with(include(user: @user))
        post 'create', params
      end
      it "logs an event" do
        post 'create', params
        session[:events].should be_include({category: "Review", action: "Create", label: ""})
      end
      context "with the ip address" do
        context "if the request header is set" do
          it "passes the source ip from the header to the model" do
            @request.env['REMOTE_ADDR'] = "127.0.0.1"
            @request.env['HTTP_X-REAL-IP'] = "128.32.42.10"
            Review.should_receive(:create!).with(include(ip_address: "128.32.42.10"))
            post 'create', params
          end
        context "if the request header is not set"
          it "passes some other ip address to the model" do
            request.env['REMOTE_ADDR'] = "10.0.0.1"
            Review.should_receive(:create!).with(include(ip_address: "10.0.0.1"))
            post 'create', params
          end
        end
      end
    end
    context 'without a signed in user' do
      it 'is not successful' do
        post 'create', params
        response.should_not be_success
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
    context 'without a signed in user' do
      it 'is not successful' do
        post 'create', params
        response.should_not be_success
      end
    end
  end
end
