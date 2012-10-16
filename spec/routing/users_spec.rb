require 'spec_helper'

describe "routes for setting user info" do
  it "routes post /users/address to users#address" do
    post("/users/address").should route_to("users#address")
  end
  it "routes post /users/reminder to users#reminder" do
    post("/users/reminder").should route_to("users#reminder")
  end
end
