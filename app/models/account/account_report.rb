module Account
  class AccountReport < ApplicationRecord
    belongs_to :account

    monetize :savings_cents
    monetize :stocks_cents
    monetize :total_cents

    validates :account_id, presence: true

    scope :current_month, lambda {
      where('date >= ? AND date <= ?',
            DateTime.current.beginning_of_month,
            DateTime.current.end_of_month).order('date asc').first
    }
  end
end
