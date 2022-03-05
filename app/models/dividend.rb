class Dividend < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_date, :create_transaction

  monetize :value_cents

  delegate :user, to: :'stock.account'

  private

  def set_date
    self.date = DateTime.current unless date
  end

  def create_transaction
    category = Category.find_or_create_by(name: 'Dividends')
    Transaction.create(
      account: stock.account,
      category_id: category.id,
      value: (value * stock.shares.past_date(date).count),
      kind: 'income',
      title: "#{stock.name} Dividend",
      date: date
    )
  end
end
