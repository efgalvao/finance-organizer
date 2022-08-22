module Account
  class Balance < ApplicationRecord
    belongs_to :account

    monetize :balance_cents

    # Balance of current month
    scope :current, lambda {
                      find_by('date BETWEEN ? AND ?', DateTime.current.beginning_of_month,
                              DateTime.current.end_of_month)
                    }

    delegate :name, to: :account, prefix: 'account'
  end
end
