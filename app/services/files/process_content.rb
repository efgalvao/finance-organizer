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
      process_transferences if content[:transferences].any?
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
      transferences = Transferences::BuildTransferences.call(content[:transferences], user_id)
      transferences.each do |transference|
        Transactions::ProcessTransference.call(transference)
      end
    end
  end
end
