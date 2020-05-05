# frozen_string_literal: true

class Api::V1::BaseController < ActionController::API
  around_action :handle_errors

  def handle_errors
    yield
  rescue ActiveRecord::InvalidForeignKey => e
    render_api_error(e.message, 422)
  rescue ActiveRecord::RecordNotFound => e
    render_api_error(e.message, 404)
  rescue ActiveRecord::RecordInvalid => e
    render_api_error(e.record.errors.full_messages, 422)
  rescue JWT::ExpiredSignature => e
    render_api_error(e.message, 422)
  rescue JWT::VerificationError => e
    render_api_error(e.message, 422)
  end

  def render_api_error(messages, code)
    data = { errors: [] }
    if messages.respond_to? :each
      messages.each do |field, errors|
        if errors.respond_to? :each
          errors.each do |error_message|
            data[:errors].push(
              status: code,
              source: { pointer: "/user/#{field}" },
              detail: error_message
            )
          end
        else
          data[:errors].push(
            status: code,
            source: { pointer: "/user/#{field}" },
            detail: errors
          )
        end
      end
    else
      data[:errors].push(code: code, details: messages)
    end

    render json: data, status: code
  end
end
