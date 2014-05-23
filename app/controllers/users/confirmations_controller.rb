module Users
  class ConfirmationsController < Devise::ConfirmationsController
    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource =
        resource_class.confirm_by_token(params[:confirmation_token])

      if resource.errors.empty?
        set_flash_message(:notice, :confirmed) if is_navigational_format?
        log_event('User', 'Confirmed')
        sign_in(resource_name, resource)
        respond_with_navigational(resource) do
          redirect_to after_confirmation_path_for(resource_name, resource)
        end
      else
        respond_with_navigational(resource.errors,
                                  status: :unprocessable_entity) do
          render :new
        end
      end
    end

    protected

    def after_resending_confirmation_instructions_path_for(resource_name)
      if signed_in?
        root_path
      else
        new_session_path(resource_name)
      end
    end
  end
end
