require 'spec_helper'

describe VoterInfo, :type => :model do
  context 'with a valid address without poll information' do
    before(:each) do
      allow(RestClient).to receive(:post)
      .and_return(
        File.open('spec/fixtures/voter_info_responses/white_house.json')
        .read)
    end
    let(:vi) { VoterInfo.lookup('DC') }
    it 'has a status of noStreetSegmentFound' do
      expect(vi.status).to eq 'noStreetSegmentFound'
    end
    it 'returns an Address object for the normalized address' do
      expect(vi.normalized_address).to be_a(Address)
    end
    it 'has a normalized version of the address' do
      expect(vi.normalized_address.city).to eq 'Washington'
    end
    it 'has an empty array of polling places' do
      expect(vi.polling_locations).to eq []
    end
  end
  context 'with a valid address with poll information' do
    context 'with polling places not in the database' do
      before(:each) do
        allow(RestClient).to receive(:post)
        .and_return(
          File.open('spec/fixtures/voter_info_responses/ks_response.json')
          .read)
      end
      let(:vi) { VoterInfo.lookup('KS') }
      it 'has a normalized version of the address' do
        expect(vi.normalized_address.city).to eq 'Kansas City'
      end
      it 'returns all the polling places' do
        expect(vi.polling_locations.length).to eq 1
      end
      context 'the polling place list' do
        it 'contains activerecord objects' do
          vi.polling_locations.each do |pl|
            expect(pl).to be_persisted
          end
        end
        it 'contains objects which are not early vote locations' do
          vi.polling_locations.each do |pl|
            expect(pl.early_vote?).to be_falsey
          end
        end
        it 'created these new objects' do
          expect do
            VoterInfo.lookup('KS').polling_locations
          end.to change { PollingLocation.count }.by(1)
        end
      end
      it 'returns all the early vote sites' do
        expect(vi.early_voting_places.length).to eq 1
      end
      context 'the early voting site list' do
        it 'contains activerecord objects' do
          vi.early_voting_places.each do |pl|
            expect(pl).to be_persisted
          end
        end
        it 'contains objects which are early vote locations' do
          vi.early_voting_places.each do |pl|
            expect(pl.early_vote?).to be_truthy
          end
        end
        it 'created these new objects' do
          expect do
            VoterInfo.lookup('KS').early_voting_places
          end.to change { PollingLocation.count }.by(1)
        end
      end
    end
  end
  context 'with a no address returned message' do
    before(:each) do
      allow(RestClient).to receive(:post)
      .and_return(
        File.open('spec/fixtures/voter_info_responses/no_address.json').read)
    end
    let(:vi) { VoterInfo.lookup('') }
    it 'has a status of noAddressParameter' do
      expect(vi.status).to eq 'noAddressParameter'
    end
    it 'returns nil for the address' do
      expect(vi.normalized_address).to be_nil
    end
    it 'has an empty polling place array' do
      expect(vi.polling_locations.length).to eq 0
    end
    it 'has an empty early voting array' do
      expect(vi.polling_locations.length).to eq 0
    end
  end
end
