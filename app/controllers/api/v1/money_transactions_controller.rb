# frozen_string_literal: true

class Api::V1::MoneyTransactionsController < Api::V1::BaseController
  before_action :authenticate_user!


  def index
    money_transactions = MoneyTransaction.all
    render json: MoneyTransactionSerializer.new(money_transactions).serializable_hash.to_json
  end

  def show
    money_transaction = MoneyTransaction.find(params[:id])
    render json: MoneyTransactionSerializer.new(money_transaction).serializable_hash.to_json
  end

  # POST /money_transactions
  def create
    @money_transaction = MoneyTransaction.new(money_transaction_params)
    if money_transaction_params.nil?
      render_api_error('parsing input', 422)
      return
    end
    @money_transaction.password_confirmation = money_transaction_params[:password] if money_transaction_params[:password].present?
    Rails.logger.warn("creating #{@money_transaction.attributes}")
    if @money_transaction.save
      render status: 201, json: MoneyTransactionSerializer.new(@money_transaction).serializable_hash.to_json
    else
      render_api_error(@money_transaction.errors, 422)
      # render json: @money_transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /money_transactions/1
  def update
    set_money_transaction
    if @money_transaction.update(money_transaction_params)
      render status: :ok, json: MoneyTransactionSerializer.new(@money_transaction).serializable_hash.to_json
    else
      render_api_error(@money_transaction.errors, 422)

      render json: @money_transaction.errors, status: 422
    end
  end

  # DELETE /money_transactions/1
  def destroy
    set_money_transaction
    @money_transaction.destroy
    head :no_content
  end

  private

  def set_money_transaction
    @money_transaction = MoneyTransaction.find(params[:id])
  end

  # Parse JSON-Api data:
  # {"data"=>{"type"=>"money_transaction",
  #           "attributes"=>{"name"=>"Good", "email"=>"good@hier.com", "password"=>"[FILTERED]"}}
  def money_transaction_params
    Rails.logger.warn(params)
    p = params.require(:data).permit(:type, attributes: %i[name email password])
    p[:attributes] if p[:type] == 'money_transaction'
  end
end
