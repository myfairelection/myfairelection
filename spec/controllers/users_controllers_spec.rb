require 'spec_helper'

describe UsersController, :type => :controller do
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
        expect(User.find(@user.id).address.city).to eq 'San Francisco'
      end
      it 'redirects to the home page' do
        post 'address', params
        expect(response).to redirect_to root_path
      end
      it 'sets the notice flash' do
        post 'address', params
        expect(flash[:notice]).not_to be_nil
      end
      it 'logs an event' do
        post 'address', params
        expect(session[:events]).to be_include(category: 'User',
                                           action: 'Save Address', label: '')
      end
    end
    context 'without a signed in user' do
      it 'redirects to signin page' do
        post 'address', params
        expect(response).to redirect_to new_user_session_path
      end
      it 'sets the error flash' do
        post 'address', params
        expect(flash[:error]).not_to be_nil
      end
    end
  end
  describe 'POST reminder' do
    let(:params) { { 'user' => { 'wants_reminder' => 'true' } } }
    context 'with a signed in user' do
      login_user
      it 'sets the signing in the user object' do
        post 'reminder', params
        expect(User.find(@user.id).wants_reminder).to be_truthy
      end
      it 'redirects to the home page' do
        post 'reminder', params
        expect(response).to redirect_to root_path
      end
      it 'sets the notice flash' do
        post 'reminder', params
        expect(flash[:notice]).not_to be_nil
      end
      it 'logs the event' do
        post 'reminder', params
        expect(session[:events]).to be_include(category: 'User',
                                           action: 'Reminder', label: 'true')
      end
    end
    context 'without a signed in user' do
      it 'redirects to signin page' do
        post 'reminder', params
        expect(response).to redirect_to new_user_session_path
      end
      it 'sets the error flash' do
        post 'reminder', params
        expect(flash[:error]).not_to be_nil
      end
    end
  end
end
