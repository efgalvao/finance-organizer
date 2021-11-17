class Price < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_date

  scope :past_date, ->(date) { where('date <= ?', date) }

  monetize :price_cents

  def self.monthly_price
    group_by_month(:date, last: 12, current: true).last
  end

  private

  def set_date
    self.date = DateTime.current unless date
  end
end
