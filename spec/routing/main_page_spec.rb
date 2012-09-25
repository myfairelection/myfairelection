require 'spec_helper'

describe "route the main page" do
  it "routes / to home#index" do
    get("/").should route_to("home#index")
  end
  it "routes /polling_place/find to polling_place#find" do
    get("/polling_place/find?address=foo").should route_to("polling_places#find")
  end
end