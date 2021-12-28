class Stock < ApplicationRecord
  has_many :dividends, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :prices, dependent: :destroy
  belongs_to :account, touch: true

  validates :name, presence: true
  validates :account, presence: true

  def name_with_account
    "#{name} (#{account.name})"
  end

  def current_price
    return 0 if prices.empty?

    prices.order('date desc').first&.price
  end

  def total_invested
    Money.new(shares.sum(:aquisition_value_cents))
  end

  def average_aquisition_price
    return 0 if shares.count.zero?

    total_invested / shares.count
  end

  def total_current_price
    return 0 if current_price.nil?

    current_price * shares.count
  end

  def updated_balance
    return 0 if prices.empty?

    price = prices.order('date desc').first&.price
    price * shares.count
  end

  def monthly_price
    grouped_prices = {}
    prices.each do |price|
      grouped_prices[price.date.strftime('%B %d, %Y').to_s] = price.price.to_f
    end
    grouped_prices
  end

  def monthly_dividends_per_share
    grouped_dividends = {}
    dividends.each do |dividend|
      grouped_dividends[dividend.date.strftime('%B/%Y').to_s] = dividend.value.to_f
    end
    grouped_dividends
  end

  def monthly_dividends_total
    grouped_dividends = {}
    dividends.each do |dividend|
      grouped_dividends[dividend.date.strftime('%B/%Y').to_s] =
        dividend.value.to_f * shares.where('aquisition_date <= ?', dividend.date).count
    end
    grouped_dividends
  end

  def past_stock_balance(date)
    price = if prices.past_date(date).order('date desc').first.nil?
              shares.past_date(date).order('aquisition_date desc').first&.aquisition_value
            else
              prices.past_date(date).order('date desc').first&.price
            end
    shares_count = shares.past_date(date).count
    price * shares_count
  end
end
