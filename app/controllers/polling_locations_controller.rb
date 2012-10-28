class PollingLocationsController < ApplicationController
  def show
    @polling_location = PollingLocation.find(params[:id])
  end
end
