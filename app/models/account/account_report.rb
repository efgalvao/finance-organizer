module Account
  class AccountReport < ApplicationRecord
    belongs_to :account

    monetize :incomes_cents
    monetize :expenses_cents
    monetize :invested_cents
    monetize :final_cents

    validates :account_id, presence: true

    scope :current_month, lambda {
      where('date >= ? AND date <= ?',
            DateTime.current.beginning_of_month,
            DateTime.current.end_of_month).order('date asc').first
    }

    scope :current_mes, -> { find_by(date: date.beginning_of_month...date.end_of_month) }
  end
end
