require 'spec_helper'

describe Address, :type => :model do
  describe '#initialize' do
    it 'works with no args' do
      a = Address.new
      expect(a).to be_a(Address)
    end
    it 'works with a valid hash' do
      a = Address.new('line1' => '631 San Bruno Ave')
      expect(a).to be_a(Address)
    end
    it 'throws an error with a non-hash' do
      expect { Address.new('This is not a hash') }.to raise_error
    end
    it 'ignores invalid keys' do
      a = Address.new('foobar' => 'garply')
      expect(a.to_h).to be_empty
    end
    it 'sets most of the getters based on the hash' do
      %w(line1 line2 line3 city zip).each do |attrib|
        a = Address.new(attrib => 'foobar')
        expect(a.send(attrib)).to eq 'foobar'
      end
    end
    it 'always converts state to uppercase' do
      expect(Address.new('state' => 'co').state).to eq 'CO'
    end
  end
  describe '#to_h' do
    it 'returns a hash with the keys in the right order' do
      a = Address.new
      a.city = 'Denver'
      a.zip = '80014'
      a.line1 = '11951 E Yale Ct'
      expect(a.to_h).to eq('line1' => '11951 E Yale Ct',
                       'city' => 'Denver',
                       'zip' => '80014')
    end
  end
  describe '#blank?' do
    it 'returns true for an empty object' do
      expect(Address.new).to be_blank
    end
    it 'returns false for an object initialized with invalid keys' do
      expect(Address.new('foobar' => 'garply')).to be_blank
    end
    it 'returns false if the object has data' do
      expect(Address.new('city' => 'San Francisco')).not_to be_blank
    end
  end
  describe 'to_s' do
    context 'with a valid address' do
      let(:addr_hash) do
        { 'line1' => '11951 E Yale Ct',
          'line2' => 'Suite 300',
          'line3' => 'Fourth Floor',
          'city' => 'Denver', 'state' => 'CO',
          'zip' => '80014' }
      end
      it 'renders the address in po format' do
        a = Address.new(addr_hash)
        expect(a.to_s).to eq "11951 E Yale Ct\nSuite 300\n" \
                         "Fourth Floor\nDenver, CO 80014\n"
      end
    end
  end
end
