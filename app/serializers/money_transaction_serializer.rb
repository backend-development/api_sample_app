# frozen_string_literal: true

class MoneyTransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :amount
  attribute :paid_at, if: Proc.new { |record|
    record.paid_at.present?
  }
  belongs_to :creditor, record_type: :user, serializer: UserSerializer
  belongs_to :debitor, record_type: :user, serializer: UserSerializer
end
