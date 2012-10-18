class UsersController < ApplicationController
  def address
    if current_user
      addr = Address.new(params)
      current_user.address = addr
      current_user.save
      flash[:notice] = "Your address has been saved."
      log_event("User", "Save Address")
      redirect_to root_path
    else
      flash[:error] = "Must be signed in"
      redirect_to new_user_session_path
    end
  end
  def reminder
    if current_user
      current_user.wants_reminder = params[:user][:wants_reminder]
      current_user.save
      if current_user.wants_reminder?
        flash[:notice] = "We will send you a reminder email on election day"
      else
        flash[:notice] = "We have canceled your election day reminder. Be sure to remember yourself!"
      end
      redirect_to root_path
    else
      flash[:error] = "Must be signed in"
      redirect_to new_user_session_path
    end
  end
end
