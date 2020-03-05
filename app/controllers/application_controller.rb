class ApplicationController < ActionController::Base
  # TODO: only verify csrf_token when authentication is done without cookies
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
end
