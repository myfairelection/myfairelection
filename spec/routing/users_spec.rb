require 'spec_helper'

describe "routes for setting user info" do
  it "routes post /users/address to users#address" do
    post("/users/address").should route_to("users#address")
  end
end