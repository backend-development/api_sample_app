# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoneyTransactionsController, type: :controller do
  fixtures :users
  fixtures :money_transactions

  let(:valid_session) do
    return {}
  end

  before(:each) do
    @money_transaction = money_transactions(:one)
  end
  it('test data exists') { expect(@money_transaction.valid?).to(eq(true)) }
  it('should get index') do
    get :index, params: {}, session: valid_session
    assert_response(:success)
  end
  it('should get new') do
    get :new, params: {}, session: valid_session
    assert_response(:success)
  end
  it('should create money_transaction') do
    expect do
      # Rails.logger.warn("creating with #{@money_transaction.amount} #{@money_transaction.creditor_id} #{@money_transaction.debitor_id}")
      post(
        :create,
        params: { id: @money_transaction.id, money_transaction: { amount: @money_transaction.amount, creditor_id: @money_transaction.creditor_id, debitor_id: @money_transaction.debitor_id } },
        session: valid_session
      )
    end.to(change { MoneyTransaction.count })
    assert_redirected_to(money_transactions_url)
  end
  it('should show money_transaction') do
    get(:show, params: { id: @money_transaction.id }, session: valid_session)
    assert_response(:success)
  end
  it('should get edit') do
    get(:edit, params: { id: @money_transaction.id }, session: valid_session)
    assert_response(:success)
  end
  it('should update money_transaction') do
    patch(:update,  params: { id: @money_transaction.id, money_transaction: { paid_at: Date.today } }, session: valid_session)
    assert_redirected_to(money_transactions_url)
  end
  it('should destroy money_transaction') do
    expect do
      delete(:destroy, params: { id: @money_transaction.to_param }, session: valid_session)
    end.to(change { MoneyTransaction.count }.by(-1))
    assert_redirected_to(money_transactions_url)
  end
end
