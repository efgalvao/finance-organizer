module Investments
  module Stock
    class Dividend < ApplicationRecord
      belongs_to :stock, touch: true

      monetize :value_cents

      delegate :user, to: :'stock.account'
      delegate :name, to: :stock, prefix: 'stock'

      # def self.create(params)
      #   new(params).tap do |dividend|
      #     dividend.date = DateTime.current unless dividend.date
      #     dividend.save!
      #     dividend.create_transaction
      #   end
      # end

      def create_transaction
        Transactions::CreateTransaction.call(
          account: stock.account,
          value: (value * stock.shares.past_date(date).count),
          kind: 'income',
          title: "#{stock.ticker} Dividend",
          date: date
        ).save
      end
    end
  end
end
