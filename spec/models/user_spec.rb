require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  it 'fails if address is not an Address' do
    expect do
      @user.address = 'This is not an address.'
      @user.save
    end.to raise_error(ActiveRecord::SerializationTypeMismatch)
  end
  it 'succeeds if address is an Address' do
    expect do
      @user.address = Address.new
      @user.save
    end.to_not raise_error
  end
  it 'does not want reminder by default' do
    @user.wants_reminder?.should be_false
  end
  it 'remembers if the user wants a reminder' do
    @user.wants_reminder = true
    @user.save
    newuser = User.find(@user.id)
    newuser.wants_reminder?.should be_true
  end
end
