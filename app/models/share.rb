class Share < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_aquisition_date

  scope :bought_this_month, lambda {
                              where('aquisition_date BETWEEN ? AND ?',
                                    DateTime.current.beginning_of_month,
                                    DateTime.current.end_of_month)
                            }

  scope :past_date, ->(date) { where('aquisition_date <= ?', date) }

  monetize :aquisition_value_cents

  def self.average_price
    average('aquisition_value')
  end

  def self.month_qty
    group_by_month(:aquisition_date, last: 12, current: true).count.each_with_object({}) do |(date, total), cumulative|
      cumulative[date] = total + (cumulative.prices.last || 0)
    end
  end

  private

  def set_aquisition_date
    self.aquisition_date = DateTime.current unless aquisition_date
  end
end
