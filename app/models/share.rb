class Share < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_aquisition_date, :set_first_price

  scope :bought_this_month, lambda {
                              where('aquisition_date BETWEEN ? AND ?',
                                    DateTime.current.beginning_of_month,
                                    DateTime.current.end_of_month)
                            }

  scope :past_date, ->(date) { where('aquisition_date <= ?', date - 7.days) }

  monetize :aquisition_value_cents

  # def self.average_price
  #   average('aquisition_value_cents')
  # end

  private

  def set_aquisition_date
    self.aquisition_date = Date.current unless aquisition_date
  end

  def set_first_price
    return unless Price.find_by(date: aquisition_date).nil?

    Price.create(
      date: aquisition_date,
      price_cents: aquisition_value_cents,
      stock: stock
    )
  end
end
