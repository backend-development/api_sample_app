# frozen_string_literal: true

json.array! @money_transactions do |money_transaction|
  json.partial! 'money_transactions/money_transaction', money_transaction: money_transaction
end
