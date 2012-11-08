class PollingLocationsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]

  def show
    @polling_location = PollingLocation.find(params[:id])
  end

  def new
    @polling_location = PollingLocation.new(state: params[:state])
  end

  # def create
  #   @polling_location = PollingLocation.new
  #   @polling_location.state = params[:polling_location][:state]
  #   @polling_location.description = params[:polling_location][:description]
  #   if @polling_location.description.blank?
  #     @polling_location.errors[:base] << "Please describe where you voted"
  #     render action: 'new'
  #   else
  #     if @polling_location.save
  #       redirect_to new_polling_location_review_path(@polling_location)
  #     else
  #       render action: 'new'
  #     end
  #   end

  # end

end
