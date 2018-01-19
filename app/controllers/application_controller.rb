# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_location

  URL_IGNORE_LIST = %w(users sistema ficha danos iniciativas preview).freeze

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User.permitted_parameters)
  end

  # Private: Store last url as long as it isn't in the ignore list. The last url
  # will be used to return the user to the previous page after login/logout.
  #
  # By default, routes exclusively created for building modals over Ajax calls
  # should be included in the ignore list. If this rule is not respected, the
  # users may face a problem like this: http://g.recordit.co/Yaac6X34z7.gif
  def store_location
    unless request.fullpath =~ /\/#{URL_IGNORE_LIST.join('|')}/
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end
end
