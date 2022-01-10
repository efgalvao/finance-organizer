class Price < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_date

  scope :past_date, ->(date) { where('date <= ?', date) }

  monetize :price_cents

  def self.get_current_price(ticker)
    PriceUpdater.get_price(ticker)
  end

  private

  def set_date
    self.date = DateTime.current unless date
  end
end
