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

  def individual_price
    price = if prices.order('date desc').first.nil?
              shares.order('aquisition_date desc').first&.aquisition_value
            else
              prices.order('date desc').first&.price
            end
    return 0 if price.nil?

    price.round(2)
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
    grouped_prices = {}
    prices.each do |price|
      grouped_prices[price.date.strftime('%B %d, %Y').to_s] = price.price.to_f
    end
    grouped_prices
  end

  def monthly_dividends
    grouped_dividends = {}
    dividends.each do |dividend|
      grouped_dividends[dividend.date.strftime('%B %d, %Y').to_s] = dividend.value.to_f
    end
    grouped_dividends
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

  def name_with_account
    "#{name} (#{account.name})"
  end
end
