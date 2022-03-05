class Share < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_aquisition_date, :set_first_price

  scope :past_date, ->(date) { where('aquisition_date <= ?', date - 7.days) }

  monetize :aquisition_value_cents

  delegate :user, to: :'stock.account'

  private

  def set_aquisition_date
    self.aquisition_date = Date.current unless aquisition_date
  end

  def set_first_price
    return unless Price.find_by(date: aquisition_date, stock_id: stock.id).nil?

    Price.create(
      date: aquisition_date,
      price_cents: aquisition_value_cents,
      stock: stock
    )
  end
end
