class HomeController < ApplicationController
  def index
    @review = Review.new(user: current_user)
  end
end
