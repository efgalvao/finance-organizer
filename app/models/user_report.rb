class UserReport < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :user

  # MONETIZE
  monetize :savings_cents
  monetize :stocks_cents
  monetize :total_cents

  # VALIDATIONS
  validates :user_id, presence: true

  before_save :set_date

  def set_date
    return if date.present?

    self.date = Date.current
  end
end
