# frozen_string_literal: true

json.extract! money_transaction, :id, :creditor_id, :debitor_id, :amount, :paid_at
json.url money_transaction_url(money_transaction, format: :json)
