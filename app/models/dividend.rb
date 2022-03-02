class Dividend < ApplicationRecord
  belongs_to :stock, touch: true

  before_create :set_date, :create_transaction

  delegate :name, to: :stock, prefix: true

  monetize :value_cents

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
