# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # TODO: only verify csrf_token when authentication is done without cookies
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json, :html

  skip_before_action :verify_authenticity_token, if: :json_request?

  before_action :coerce_json

  def coerce_json
    request.format = :json if json_request?
  end

  def json_request?
    request.headers['HTTP_ACCEPT'] =~ /^\s*application\/json/
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password) }
  end
end
