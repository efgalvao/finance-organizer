module Transactions
  class BuildTransactions
    def initialize(content)
      @content = content
    end

    def self.call(content)
      new(content).call
    end

    def call
      build_transactions
    end

    private

    attr_reader :content

    def build_transactions
      content.map do |transaction|
        build_transaction(transaction)
      end
    end

    def build_transaction(transaction)
      {
        "kind": transaction[:kind],
        "title": transaction[:title],
        "account_id": account_id(transaction[:account]),
        "category_id": category_id(transaction[:category]),
        "value": transaction[:value],
        "date": transaction[:date]
      }
    end

    def account_id(account_name)
      Account::Account.find_by(name: account_name)&.id
    end

    def category_id(category_name)
      Category.find_by(name: category_name)&.id.presence || Category.find_by(name: 'Diversos')&.id
    end
  end
end
