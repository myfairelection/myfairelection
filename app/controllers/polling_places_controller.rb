class PollingPlacesController < ApplicationController
  def find
    address = params[:address]
    @polling_place = PollingPlace.lookup(address)
  end
end
