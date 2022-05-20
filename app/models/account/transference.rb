module Account
  class Transference < ApplicationRecord
    belongs_to :sender, class_name: 'Account'
    belongs_to :receiver, class_name: 'Account'
    belongs_to :user

    monetize :amount_cents

    validates :amount, presence: true
    validate :different_accounts

    scope :current_month, -> { where('date >= ?', Date.current.beginning_of_month) }

    before_save :set_date

    delegate :name, to: :sender, prefix: 'sender'
    delegate :name, to: :receiver, prefix: 'receiver'

    def different_accounts
      errors.add :base, 'Accounts must be different' if sender_id == receiver_id
    end

    private

    def set_date
      self.date = Date.current unless date
    end
  end
end
