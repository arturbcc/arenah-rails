# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :store_location

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User.permitted_parameters)
  end

  def store_location
    unless request.fullpath =~ /\/users/ || request.fullpath =~ /\/sistema/
      # store last url as long as it isn't a /users path or a /sistema path
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
end
