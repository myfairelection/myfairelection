require 'spec_helper'

describe StateMapController, :type => :controller do

  describe 'GET index' do
    it 'returns http success' do
      get 'index'
      expect(response).to be_success
    end
    it 'renders the index' do
      get 'index'
      expect(response).to render_template('index')
    end
  end

  describe 'GET states' do
    context 'html' do
      it 'renders the states html template' do
        get 'states'
        expect(response).to render_template('states')
      end
      it 'passes an array of state data to the template' do
        get 'states'
        expect(assigns[:states]).not_to be_nil
      end
    end
  end

end
