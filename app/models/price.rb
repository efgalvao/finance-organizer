class Price < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_date

  monetize :price_cents

  private

  def set_date
    self.date = DateTime.current unless date
  end
end
