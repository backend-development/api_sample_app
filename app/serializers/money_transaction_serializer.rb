# frozen_string_literal: true

class MoneyTransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :amount, :paid_at
  belongs_to :creditor, record_type: :user, serializer: UserSerializer
  belongs_to :debitor, record_type: :user, serializer: UserSerializer
end
