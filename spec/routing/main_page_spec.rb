require 'spec_helper'

describe 'route the main page', type: :routing do
  it 'routes / to home#index' do
    expect(get('/')).to route_to('home#index')
  end
  it 'routes /voter_info/find to voter_info#find' do
    expect(get: '/voter_info/find?address=foo').to route_to(
        controller: 'voter_info',
        action: 'find',
        address: 'foo')
  end
end
