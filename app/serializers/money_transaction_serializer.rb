# frozen_string_literal: true

class MoneyTransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :email
end
