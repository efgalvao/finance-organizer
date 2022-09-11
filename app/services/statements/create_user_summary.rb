module Statements
  class CreateUserSummary
    def initialize(reports:)
      @reports = reports
    end

    def self.call(reports:)
      new(reports: reports).call
    end

    def call
      mount_summary
    end

    private

    attr_reader :reports

    def mount_summary
      summary = { total: {}, savings: {}, stocks: {} }
      reports.each do |report|
        summary[:total][report.date.strftime('%B %d, %Y').to_s] = report.total.to_f
        summary[:savings][report.date.strftime('%B %d, %Y').to_s] = report.savings.to_f
        summary[:stocks][report.date.strftime('%B %d, %Y').to_s] = report.stocks.to_f
      end
      summary
    end
  end
end
