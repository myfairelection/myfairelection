class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :site_shutoff?

  # below is per https://github.com/plataformatec/devise/wiki/How-To:-redirect-to-a-specific-page-on-successful-sign-in
  def after_sign_in_path_for(resource)                                                                                                                      
    if request.referer.include?("/users")                                                                                                                 
      super                                                                                                                                                 
    else         
      stored_location_for(resource) || request.referer || root_path                                                                                         
    end                                                                                                                                                     
  end              
  # below is per http://stackoverflow.com/questions/9283763/how-do-i-use-google-analytics-custom-events-inside-my-rails-controller
  def log_event(category, action, label = "")
    session[:events] ||= Array.new
    session[:events] << {:category => category, :action => action, :label => label}
  end

  def fail_if_site_shutoff
    raise "Site is shut off" if site_shutoff?
  end

  def site_shutoff?
    return Settings['shutoff']
  end
end
