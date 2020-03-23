# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  def index
    users = User.all
    render json: UserSerializer.new(users).serialized_json
  end

  def show
    user = User.find(params[:id])
    render json: UserSerializer.new(user).serialized_json
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.password_confirmation = user_params[:password] if user_params[:password].present?
    Rails.logger.warn("creating #{@user.attributes}")
    if @user.save
      render status: 201, json: UserSerializer.new(@user).serialized_json
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    set_user
    if @user.update(user_params)
      render status: :ok, json: UserSerializer.new(@user).serialized_json
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :password)
  end
end
