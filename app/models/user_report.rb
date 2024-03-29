class UserReport < ApplicationRecord
  belongs_to :user

  monetize :savings_cents
  monetize :stocks_cents
  monetize :incomes_cents
  monetize :expenses_cents
  monetize :dividends_cents
  monetize :card_expenses_cents
  monetize :invested_cents
  monetize :final_cents
  monetize :total_cents

  validates :user_id, presence: true
end
