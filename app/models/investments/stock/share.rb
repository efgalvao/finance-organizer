module Investments
  module Stock
    class Share < ApplicationRecord
      belongs_to :stock, touch: true

      monetize :invested_cents

      delegate :user, to: :'stock.account'
      delegate :name, :account, to: :stock, prefix: 'stock'
    end
  end
end
