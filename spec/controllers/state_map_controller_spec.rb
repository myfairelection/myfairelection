require 'spec_helper'

describe StateMapController do

  describe 'GET index' do
    it 'returns http success' do
      get 'index'
      response.should be_success
    end
    it 'renders the index' do
      get 'index'
      response.should render_template('index')
    end
  end

  describe 'GET states' do
    context 'html' do
      it 'renders the states html template' do
        get 'states'
        response.should render_template('states')
      end
      it 'passes an array of state data to the template' do
        get 'states'
        assigns[:states].should_not be_nil
      end
    end
  end

end
