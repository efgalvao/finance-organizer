class Balance < ApplicationRecord
  belongs_to :account

  before_create :set_date

  monetize :balance_cents

  # Balance of current month
  scope :current, lambda {
                    where('date BETWEEN ? AND ?', DateTime.current.beginning_of_month,
                          DateTime.current.end_of_month).limit(1)
                  }

  scope :newest_balance, -> { order('date desc').limit(1) }

  private

  def set_date
    self.date = DateTime.current unless date
  end
end
