class Balance < ApplicationRecord
  belongs_to :balanceable, polymorphic: true, touch: true

  before_create :set_date

  monetize :balance_cents

  scope :past_date, lambda { |date|
                      where('date BETWEEN ? AND ?',
                            date.beginning_of_month, date.end_of_month)
                    }

  # Balance of current month
  scope :current, lambda {
                    where('date BETWEEN ? AND ?', DateTime.current.beginning_of_month,
                          DateTime.current.end_of_month).limit(1)
                  }

  scope :newest_balance, -> { order('date desc').first }

  def self.monthly_balance
    generate_balance if balances.empty?
    balancos = {}
    balances.each do |balance|
      balancos[balance.date.strftime('%B/%Y').to_s] = balance.balance.to_f
    end
    # balances.group_by_month(:date, last: 12, current: true).maximum(humanized_money @money_object	)
    balancos
  end

  private

  def set_date
    self.date = DateTime.current unless date
  end
end
