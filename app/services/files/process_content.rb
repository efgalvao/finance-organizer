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
      process_transactions if (content[:transactions].presence || []).any?
      process_transferences if (content[:transferences].presence || []).any?
      process_parcels_transactions if (content[:credit].presence || []).any?
      process_invoice_payments if (content[:invoices].presence || []).any?
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
        Transferences::ProcessTransference.call(transference)
      end
    end

    def process_parcels_transactions
      transactions = Transactions::BuildParcelsTransactions.call(content[:credit])
      transactions.each do |transaction|
        Transactions::ProcessCreditTransaction.call(transaction)
      end
    end

    def process_invoice_payments
      payments = Invoices::BuildInvoicePayments.call(content[:invoices])
      payments.each do |payment|
        Invoices::ProcessInvoicePayment.call(payment)
      end
    end
  end
end
