class ApplicationController < ActionController::Base
  # TODO: only verify csrf_token when authentication is done without cookies
  before_action :configure_permitted_parameters, if: :devise_controller?



  skip_before_action :verify_authenticity_token, if: :json_request?

  before_action :coerce_json

  def coerce_json
    if json_request?
      request.format = :json
    end
  end

  def json_request?
    request.headers[ 'HTTP_ACCEPT' ] =~ /^\s*application\/json/
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password)}
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
    end  
end
