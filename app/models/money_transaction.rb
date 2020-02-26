# frozen_string_literal: true

class MoneyTransaction < ApplicationRecord
  belongs_to :creditor, class_name: 'User'
  belongs_to :debitor, class_name: 'User'

  validates :amount, presence: true, numericality: { greater_than: 0 }

  validate :check_creditor_and_debitor

  def check_creditor_and_debitor
    errors.add(:debitor_id, "can't be the same as creditor") if creditor_id == debitor_id
  end
end
