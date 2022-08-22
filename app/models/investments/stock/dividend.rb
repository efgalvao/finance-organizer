module Investments
  module Stock
    class Dividend < ApplicationRecord
      belongs_to :stock, touch: true

      monetize :value_cents

      delegate :user, to: :'stock.account'
      delegate :name, to: :stock, prefix: 'stock'
    end
  end
end
