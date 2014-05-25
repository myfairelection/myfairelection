require 'spec_helper'

describe 'routes for the map', :type => :routing do
  it 'routes /map to state_map#index' do
    expect(get('/map')).to route_to('state_map#index')
  end
  it 'routes /map/states to state_map#states' do
    expect(get('/map/states')).to route_to('state_map#states')
  end
end
