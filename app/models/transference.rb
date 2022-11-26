class Transference < ApplicationRecord
  belongs_to :sender, class_name: 'Account::Account'
  belongs_to :receiver, class_name: 'Account::Account'
  belongs_to :user

  monetize :value_cents

  validates :value, presence: true
  validate :different_accounts

  scope :current_month, -> { where('date >= ?', Date.current.beginning_of_month) }

  delegate :name, to: :sender, prefix: 'sender'
  delegate :name, to: :receiver, prefix: 'receiver'

  def different_accounts
    errors.add :base, 'Accounts must be different' if sender_id == receiver_id
  end
end
