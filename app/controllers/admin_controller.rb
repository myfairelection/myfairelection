class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize

  def index
    @reviews = Review.order('id DESC').limit(10)
  end

  def authorize
    render :text => "403 Permission denied", :status => 403 unless current_user.admin?
  end
end
