module Investments
  module Stock
    class Stock < ApplicationRecord
      has_many :dividends, dependent: :destroy
      has_many :shares, dependent: :destroy
      has_many :prices, dependent: :destroy
      belongs_to :account, class_name: 'Account::Account', touch: true

      monetize :current_total_value_cents, :invested_value_cents, :current_value_cents

      validates :ticker, presence: true
      validates :account, presence: true

      delegate :user, :name, to: :account, prefix: 'account'
      delegate :id, to: :'account.user', prefix: 'user'

      def ticker_with_account
        "#{ticker} (#{account.name})"
      end

      def average_aquisition_price
        return 0 if shares_total.zero?

        invested_value / shares_total
      end

      def last_semester_prices
        grouped_prices = {}
        semester_prices.each do |price|
          grouped_prices[price.date.strftime('%B %d, %Y').to_s] = price.value.to_f
        end
        grouped_prices
      end

      # def last_semester_individual_dividends
      #   grouped_dividends = {}
      #   last_semester_dividends.each do |dividend|
      #     grouped_dividends[dividend.date.strftime('%B/%Y').to_s] = dividend.value.to_f
      #   end
      #   grouped_dividends
      # end

      # def semester_total_dividends
      #   grouped_dividends = {}
      #   last_semester_dividends.each do |dividend|
      #     # binding.pry
      #     grouped_dividends[dividend.date.strftime('%B/%Y').to_s] =
      #       dividend.value.to_f * shares.where('date <= ?', dividend.date).sum(:quantity)
      #   end
      #   grouped_dividends
      # end

      private

      def semester_prices
        prices.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
      end

      # def last_semester_dividends
      #   dividends.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
      # end
    end
  end
end
