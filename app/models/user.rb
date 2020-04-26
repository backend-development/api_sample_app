class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :validatable
  has_many :credits, class_name: "MoneyTransaction", foreign_key: "creditor_id"
  has_many :debts, class_name: "MoneyTransaction", foreign_key: "debitor_id"  

  validates :email, :name, presence: true
  validates :email, :name, uniqueness: true


  def to_s
    name 
  end
end
