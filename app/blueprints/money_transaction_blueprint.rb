# frozen_string_literal: true

class MoneyTransactionBlueprint < Blueprinter::Base
  identifier :id

  fields :amount, :paid_at, :creditor_id, :debitor_id

  view :with_users do
    fields :amount, :paid_at
    association :creditor, blueprint: UserBlueprint
    association :debitor, blueprint: UserBlueprint  
  end
end
