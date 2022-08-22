class User < ApplicationRecord
  has_many :reports, class_name: 'UserReport', dependent: :destroy
  has_many :accounts, class_name: 'Account::Account', dependent: :destroy
  has_many :transferences, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
end
