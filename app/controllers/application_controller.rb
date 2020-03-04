class ApplicationController < ActionController::Base
  before_action :coerce_json

	def coerce_json
		# Rails converts the following header:
		#
		#	Accept: application/json, text/javascript, */*; q=0.01
		#
		# into text/html. Force it back to json.
		if request.headers[ 'HTTP_ACCEPT' ] =~ /^\s*application\/json/
			request.format = 'json'
		end
	end
end
