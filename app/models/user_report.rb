class UserReport < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :user

  # MONETIZE
  monetize :savings_cents
  monetize :stocks_cents
  monetize :total_cents

  # VALIDATIONS
  validates :user_id, presence: true

  # SCOPES
  scope :current_month, lambda {
    where('date >= ? AND date <= ?',
          DateTime.current.beginning_of_month,
          DateTime.current.end_of_month).order('date asc').first
  }

  before_save :set_date

  def set_date
    return if date.present?

    self.date = Date.current
  end
end
