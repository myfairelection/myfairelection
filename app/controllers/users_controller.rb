class UsersController < ApplicationController
  def address
    if current_user
      addr = Address.new(params)
      current_user.address = addr
      current_user.save
      flash[:notice] = "Your address has been saved."
      redirect_to root_path
    else
      flash[:error] = "Must be signed in"
      redirect_to new_user_session_path
    end
  end
end
