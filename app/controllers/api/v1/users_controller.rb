# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!
  around_action :handle_errors

  def handle_errors
    yield
  rescue ActiveRecord::InvalidForeignKey => e
    render_api_error(e.message, 422)
  rescue ActiveRecord::RecordNotFound => e
    render_api_error(e.message, 404)
  rescue ActiveRecord::RecordInvalid => e
    render_api_error(e.record.errors.full_messages, 422)
    # rescue JWT::ExpiredSignature => e
    #   render_api_error(e.message, 401)
    # rescue InvalidTokenError => e
    #   render_api_error(e.message, 422)
    # rescue MissingTokenError => e
    #   render_api_error(e.message, 422)
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

  def index
    users = User.all
    render json: UserSerializer.new(users).serializable_hash.to_json
  end

  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user).serializable_hash.to_json
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if user_params.nil?
      render_api_error('parsing input', 422)
      return
    end
    @user.password_confirmation = user_params[:password] if user_params[:password].present?
    Rails.logger.warn("creating #{@user.attributes}")
    if @user.save
      render status: 201, json: UserSerializer.new(@user).serializable_hash.to_json
    else
      render_api_error(@user.errors, 422)
      # render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    set_user
    if @user.update(user_params)
      render status: :ok, json: UserSerializer.new(@user).serializable_hash.to_json
    else
      render_api_error(@user.errors, 422)

      render json: @user.errors, status: 422
    end
  end

  # DELETE /users/1
  def destroy
    set_user
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Parse JSON-Api data:
  # {"data"=>{"type"=>"user",
  #           "attributes"=>{"name"=>"Good", "email"=>"good@hier.com", "password"=>"[FILTERED]"}}
  def user_params
    Rails.logger.warn(params)
    p = params.require(:data).permit(:type, attributes: %i[name email password])
    p[:attributes] if p[:type] == 'user'
  end
end
