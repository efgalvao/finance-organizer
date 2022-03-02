module Transactions
  class CreateInvestment < ApplicationService
    def initialize(params, quantity)
      @params = params
      @quantity = quantity
    end

    def perform
      share = create_share(params)
      if share.valid?
        Share.transaction do
          quantity.times do
            Share.create(params)
            Transaction.create(account: share.stock.account, value: share.aquisition_value, kind: 'investment',
                               title: "Purchase share of Stock #{share.stock_name}", date: share.aquisition_date)
            share.stock.account.update_balance(-share.aquisition_value)
          end
        end
      end
      share
    end

    private

    attr_reader :params, :quantity

    def create_share(params)
      Share.new(params)
    end
  end
end
