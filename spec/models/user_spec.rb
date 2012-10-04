require 'spec_helper'

describe User do
  it "allows more than one user without an email address" do
    User.create!({username: "test1", 
                  provider: "twitter", 
                       uid: "1", 
                     email: ""}, :without_protection => true)
    expect {
      User.create!({username: "test2", 
                    provider: "twitter", 
                         uid: "2", 
                       email: ""}, :without_protection => true)
    }.to_not raise_error
  end
end
