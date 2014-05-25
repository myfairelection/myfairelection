require 'spec_helper'

describe ApplicationController, type: :controller do

  describe '#log_event' do
    it 'writes an event into the session for use by GA in the view' do
      controller.log_event('category', 'action', 'label')
      expect(session[:events]).to be_include(category: 'category',
                                             action: 'action', label: 'label')
    end
  end

end
