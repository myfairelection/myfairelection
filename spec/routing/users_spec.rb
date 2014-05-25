require 'spec_helper'

describe 'routes for setting user info', type: :routing do
  it 'routes post /users/address to users#address' do
    expect(post('/users/address')).to route_to('users#address')
  end
  it 'routes post /users/reminder to users#reminder' do
    expect(post('/users/reminder')).to route_to('users#reminder')
  end
end
