require 'spec_helper'

describe ApplicationController do

  describe '#log_event' do
    it 'writes an event into the session for use by GA in the view' do
      controller.log_event('category', 'action', 'label')
      session[:events].should be_include(category: 'category',
                                         action: 'action', label: 'label')
    end
  end

end
