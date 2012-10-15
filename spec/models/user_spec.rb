require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  it "fails if address is not an Address" do
    expect {    
      @user.address = "This is not an address."
      @user.save
    }.to raise_error(ActiveRecord::SerializationTypeMismatch)
  end
  it "succeeds if address is an Address" do
    expect {
      @user.address = Address.new
      @user.save
    }.to_not raise_error
  end
end
