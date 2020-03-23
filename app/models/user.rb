class User < ApplicationRecord
  has_many :credits, class_name: "MoneyTransaction", foreign_key: "creditor_id"
  has_many :debts, class_name: "MoneyTransaction", foreign_key: "debitor_id"  
  has_secure_password

  validates :email, :name, presence: true
  validates :email, :name, uniqueness: true


  def to_s
    name 
  end
end
