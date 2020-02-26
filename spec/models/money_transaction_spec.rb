# frozen_string_literal: true

require('rails_helper')
RSpec.describe(MoneyTransaction, type: :model) do
  fixtures :money_transactions
  fixtures :users

  before do
    @money_transaction = money_transactions(:one)
    @user1 = users(:mando)
    @user2 = users(:greef)
  end

  it('money transaction can only have positive amount') do
    mt = MoneyTransaction.create(debitor: @user1, creditor: @user2, amount: -2)
    expect(mt).to be_invalid
  end

  it('money transaction can not have zero amount') do
    mt = MoneyTransaction.create(debitor: @user1, creditor: @user2, amount: 0)
    expect(mt).to be_invalid
  end

  it('money transaction can not have same debitor and creditor') do
    mt = MoneyTransaction.create(debitor: @user1, creditor: @user1, amount: 10)
    expect(mt).to be_invalid
  end

  it('money transaction can be created') do
    mt = MoneyTransaction.create(debitor: @user1, creditor: @user2, amount: 10)
    expect(mt).to be_valid
  end
end
