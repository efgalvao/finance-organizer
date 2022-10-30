module Files
  class ProcessContent
    def initialize(content, user_id)
      @content = content
      @user_id = user_id
    end

    def self.call(content, user_id)
      new(content, user_id).call
    end

    def call
      process_transactions if content[:transactions].any?
      # TODO
      # process_transferences if content[:transferences].any?
    end

    private

    attr_reader :content, :user_id

    def process_transactions
      transactions = Transactions::BuildTransactions.call(content[:transactions])
      transactions.each do |transaction|
        Transactions::ProcessTransaction.call(transaction)
      end
    end

    def process_transferences
      # TODO: create
      transferences = build_transferences
      transferences.each do |transference|
        Transactions::ProcessTransference.call(transference, user_id)
      end
    end
  end
end
