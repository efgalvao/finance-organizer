class Stock < ApplicationRecord
  has_many :dividends, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :prices, dependent: :destroy
  belongs_to :account, touch: true

  def sell(amount, price)
    total_value = amount * price
    account.balance += total_value
    shares.first(amount).destroy
  end

  def total_invested
    shares.sum(:aquisition_value_cents).round(2)
  end

  def updated_balance
    price = if prices.order('date desc').first.nil?
              shares.order('aquisition_date desc').first&.aquisition_value
            else
              prices.order('date desc').first&.price
            end
    return 0 if price.nil?
    (price * shares.count).round(2)
  end

  def current_price
    if prices.order('date desc').first&.price.nil?
      shares.order('aquisition_date desc').first&.aquisition_value
    else
      prices.order('date desc').first&.price
    end
  end

  def total_current_price
    return 0 if current_price.nil?

    current_price * shares.count
  end

  def monthly_price
    if prices.empty?
      shares.group_by_month(:aquisition_date, last: 12, current: true).average('aquisition_value')
    else
      pricess.group_by_month(:date, last: 12, current: true).average('price')
    end
  end

  def past_stock_balance(date)
    price = if pricess.past_date(date).order('date desc').first.nil?
              shares.past_date(date).order('aquisition_date desc').first&.aquisition_value
            else
              prices.past_date(date).order('date desc').first&.price
            end
    shares_count = shares.past_date(date).count
    price * shares_count
  end
end
