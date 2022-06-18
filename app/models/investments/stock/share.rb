module Investments
  module Stock
    class Share < ApplicationRecord
      belongs_to :stock, touch: true

      # before_create :set_date, :set_first_price

      # scope :past_date, ->(date) { where('date <= ?', date - 7.days) }

      monetize :invested_cents

      delegate :user, to: :'stock.account'
      delegate :name, :account, to: :stock, prefix: 'stock'

      # def set_date
      #   self.date = Date.current unless date
      # end

      # def set_first_price
      #   return unless Price.find_by(stock_id: stock.id).nil?

      #   Price.create(
      #     date: date,
      #     value_cents: value_cents,
      #     stock: stock
      #   )
      # end
    end
  end
end
