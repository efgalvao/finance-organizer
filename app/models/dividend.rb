class Dividend < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_date, :create_transaction

  monetize :value_cents

  # def self.monthly_dividend
  #   group_by_month(:date, last: 12, current: true).maximum('value')
  # end

  private

  def set_date
    self.date = DateTime.current unless date
  end

  def create_transaction
    Transaction.create(
      account: stock.account,
      category_id: Category.find_by(name: 'Dividends').id,
      value_cents: (value_cents * stock.shares.count),
      kind: 'income',
      title: "#{stock.name} Dividend",
      date: date
    )
  end
end
