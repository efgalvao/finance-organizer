module Account
  class Account < ApplicationRecord
    belongs_to :user
    has_many :transactions, dependent: :destroy
    has_many :balances, dependent: :destroy
    has_many :sender_transference, class_name: 'Transference', foreign_key: 'sender_id', dependent: :destroy
    has_many :receiver_transference, class_name: 'Transference', foreign_key: 'receiver_id', dependent: :destroy
    has_many :treasuries, class_name: 'Investments::Treasury::Treasury', dependent: :destroy
    has_many :stocks, class_name: 'Investments::Stock::Stock', dependent: :destroy
    has_many :reports, class_name: 'Account::AccountReport', dependent: :destroy

    monetize :balance_cents

    enum kind: { savings: 0, broker: 1, card: 2 }

    scope :card_accounts, -> { where(kind: 'card') }
    scope :except_card_accounts, -> { where.not(kind: 'card') }
    scope :broker_accounts, -> { where(kind: 'broker') }

    validates :name, presence: true, uniqueness: true
    validates :kind, presence: true

    def total_invested
      total = 0
      stocks.each do |stock|
        total += stock.invested_value
      end
      total
    end

    def owner?(asker)
      user == asker
    end

    # def not_released_treasuries
    #   treasuries.where(released_at: nil)
    # end
  end
end
