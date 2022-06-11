module Account
  class Balance < ApplicationRecord
    belongs_to :account

    monetize :balance_cents

    # Balance of current month
    scope :current, lambda {
                      where('date BETWEEN ? AND ?', DateTime.current.beginning_of_month,
                            DateTime.current.end_of_month).limit(1)
                    }

    scope :newest_balance, -> { order('date desc').limit(1) }

    delegate :name, to: :account, prefix: 'account'
  end
end
