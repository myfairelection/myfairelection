require 'spec_helper'

describe AdminController, :type => :controller do
  describe 'GET index' do
    context 'not logged in' do
      it 'is not successful' do
        get 'index'
        expect(response).not_to be_success
      end
    end
    context 'logged in as a non admin' do
      login_user
      it 'is not successful' do
        get 'index'
        expect(response).not_to be_success
      end
    end
    context 'logged in as an admin' do
      login_admin
      it 'is successful' do
        get 'index'
        expect(response).to be_success
      end
      it 'renders the index template' do
        get 'index'
        expect(response).to render_template('admin/index')
      end
      it 'passes a list of reviews' do
        get 'index'
        expect(assigns[:reviews]).not_to be_nil
      end
    end
  end
end
