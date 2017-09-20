class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  acts_as_token_authentication_handler_for User, fallback: :none
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end


  def after_sign_in_path_for(resource)
    event_path(current_user)
  end
end
