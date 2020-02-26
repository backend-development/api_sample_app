# frozen_string_literal: true

class CreateMoneyTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :money_transactions do |t|
      t.references :creditor, foreign_key: { to_table: 'users' }
      t.references :debitor, foreign_key: { to_table: 'users' }
      t.string :amount, :decimal, precision: 8, scale: 2
      t.date :paid_at, null: true

      t.timestamps
    end
  end
end
