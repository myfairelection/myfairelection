require 'spec_helper'

describe "routes for the map" do
  it "routes /map to state_map#index" do
    get("/map").should route_to("state_map#index")
  end
  it "routes /map/states to state_map#states" do
    get("/map/states").should route_to("state_map#states")
  end
end