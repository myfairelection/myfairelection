class ApplicationController < ActionController::Base
  protect_from_forgery

  # below is per http://stackoverflow.com/questions/9283763/how-do-i-use-google-analytics-custom-events-inside-my-rails-controller
  def log_event(category, action, label = "")
    session[:events] ||= Array.new
    session[:events] << {:category => category, :action => action, :label => label}
  end
end
