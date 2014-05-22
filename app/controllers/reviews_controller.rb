class ReviewsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :fail_if_site_shutoff, only: [:create]

  def create
    polling_location = PollingLocation.find(params[:polling_location_id])
    user = current_user
    ip_address = request.env['HTTP_X-REAL-IP']
    ip_address ||= request.env['REMOTE_ADDR']
    @review = Review.new(params[:review]
                           .merge(user: user,
                                  polling_location: polling_location,
                                  ip_address: ip_address))
    if @review.save
      flash[:notice] = 'Thank you for your review!'
      log_event('Review', 'Create')
      redirect_to polling_location_path(polling_location)
    else
      render action: 'new'
    end
  end

  def new
    polling_location = PollingLocation.find(params[:polling_location_id])
    @review = Review.new(polling_location: polling_location,
                         user: current_user)
  end
end
