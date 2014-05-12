require 'spec_helper'

describe UsersController do
  describe 'POST address' do
    let(:params) do
      { 'line1' => '631 San Bruno Ave',
        'city' => 'San Francisco',
        'state' => 'CA', 'zip' => '94107',
        'commit' => 'Save this information' }
    end
    context 'with a signed in user' do
      login_user
      it 'saves the address in the current user object' do
        post 'address', params
        User.find(@user.id).address.city.should eq 'San Francisco'
      end
      it 'redirects to the home page' do
        post 'address', params
        response.should redirect_to root_path
      end
      it 'sets the notice flash' do
        post 'address', params
        flash[:notice].should_not be_nil
      end
      it 'logs an event' do
        post 'address', params
        session[:events].should be_include(category: 'User',
                                           action: 'Save Address', label: '')
      end
    end
    context 'without a signed in user' do
      it 'redirects to signin page' do
        post 'address', params
        response.should redirect_to new_user_session_path
      end
      it 'sets the error flash' do
        post 'address', params
        flash[:error].should_not be_nil
      end
    end
  end
  describe 'POST reminder' do
    let(:params) { { 'user' => { 'wants_reminder' => 'true' } } }
    context 'with a signed in user' do
      login_user
      it 'sets the signing in the user object' do
        post 'reminder', params
        User.find(@user.id).wants_reminder.should be_true
      end
      it 'redirects to the home page' do
        post 'reminder', params
        response.should redirect_to root_path
      end
      it 'sets the notice flash' do
        post 'reminder', params
        flash[:notice].should_not be_nil
      end
      it 'logs the event' do
        post 'reminder', params
        session[:events].should be_include(category: 'User',
                                           action: 'Reminder', label: 'true')
      end
    end
    context 'without a signed in user' do
      it 'redirects to signin page' do
        post 'reminder', params
        response.should redirect_to new_user_session_path
      end
      it 'sets the error flash' do
        post 'reminder', params
        flash[:error].should_not be_nil
      end
    end
  end
end
