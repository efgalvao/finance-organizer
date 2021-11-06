class Dividend < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_date

  monetize :value_cents

  def self.monthly_dividend
    group_by_month(:date, last: 12, current: true).maximum('value')
  end

  private

  def set_date
    self.date = DateTime.current unless date
  end
end
