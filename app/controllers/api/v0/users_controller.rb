# frozen_string_literal: true

class Api::V0::UsersController < Api::V0::BaseController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:create]

  def index
    render json: UserBlueprint.render(User.all)
  end

  def show
    user = User.find(params[:id])
    render json: UserBlueprint.render(user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    Rails.logger.warn(params)
    p = params.require(:data).permit(:type, attributes: %i[name email password])
    p[:attributes] if p[:type] == 'user'
  end
end
