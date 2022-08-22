module Account
  class AccountReport < ApplicationRecord
    belongs_to :account

    monetize :incomes_cents
    monetize :expenses_cents
    monetize :invested_cents
    monetize :final_cents
    monetize :dividends_cents
    validates :account_id, presence: true
  end
end
