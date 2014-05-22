module Users
  class RegistrationsController < Devise::RegistrationsController
    # POST /resource
    def create
      build_resource

      if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)
          log_event('User', 'Registered')
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          if is_navigational_format?
            set_flash_message :notice,
                              :"signed_up_but_#{resource.inactive_message}"
          end
          expire_session_data_after_sign_in!
          respond_with resource,
                       location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        respond_with resource
      end
    end
  end
end
