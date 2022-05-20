module Investments
  module Stock
    class Price < ApplicationRecord
      belongs_to :stock, touch: true

      before_create :set_date

      monetize :value_cents

      delegate :user, to: :'stock.account'
      delegate :name, to: :stock, prefix: 'stock'

      private

      def set_date
        self.date = DateTime.current unless date
      end
    end
  end
end
