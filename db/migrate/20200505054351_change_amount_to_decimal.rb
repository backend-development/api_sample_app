# frozen_string_literal: true

class ChangeAmountToDecimal < ActiveRecord::Migration[6.0]
  def up
    change_column :money_transactions, :amount, 'decimal(10,2) USING CAST(amount AS decimal(10,2))'
    remove_column :money_transactions, :decimal
  end

  def down
    change_column :money_transactions, :amount, :string
    add_column :money_transactions, :decimal, :string
  end
end
