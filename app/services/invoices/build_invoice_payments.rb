module Invoices
  class BuildInvoicePayments
    def initialize(content)
      @content = content
    end

    def self.call(content)
      new(content).call
    end

    def call
      build_invoice_payments
    end

    private

    attr_reader :content

    def build_invoice_payments
      content.map do |payment|
        build_invoice_payment(payment)
      end
    end

    def build_invoice_payment(payment)
      {
        "sender_id": account_id(payment[:sender]),
        "receiver_id": account_id(payment[:receiver]),
        "date": payment[:date],
        "value": payment[:value]
      }
    end

    def account_id(account_name)
      Account::Account.find_by(name: account_name)&.id
    end
  end
end
