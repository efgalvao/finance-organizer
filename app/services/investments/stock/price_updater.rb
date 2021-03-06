module Investments
  module Stock
    class PriceUpdater
      def self.get_price(ticker)
        url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=#{ticker}.SAO&apikey=#{ENV['ALPHAVANTAGE_API_KEY']}"
        response = RestClient.get(url)
        json = JSON.parse(response)
        { value: json['Global Quote']['05. price'].to_f.round(2),
          date: json['Global Quote']['07. latest trading day'] }
      end
    end
  end
end
