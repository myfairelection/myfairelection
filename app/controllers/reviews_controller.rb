class ReviewsController < ApplicationController
  before_filter :authenticate_user!
  def create
    polling_location = PollingLocation.find(params[:polling_location_id])
    user = current_user
    ip_address = request.env['HTTP_X-REAL-IP'] 
    ip_address ||= request.env['REMOTE_ADDR']
    Review.create!(params[:review].merge({user: user, polling_location: polling_location, ip_address: ip_address}))
    flash[:notice] = "Thank you for your review!"
    redirect_to polling_location_path(polling_location)
  end
  def new
    polling_location = PollingLocation.find(params[:polling_location_id])
    @review = Review.new(polling_location: polling_location, user: current_user)
  end
end
