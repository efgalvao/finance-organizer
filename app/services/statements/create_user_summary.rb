module Statements
  class CreateUserSummary
    attr_reader :semester_reports

    def initialize(semester_reports)
      @semester_reports = semester_reports
    end

    def perform
      mount_summary
    end

    private

    def mount_summary
      summary = { total: {}, savings: {}, stocks: {} }
      semester_reports.each do |report|
        summary[:total][report.date.strftime('%B %d, %Y').to_s] = report.total.to_f
        summary[:savings][report.date.strftime('%B %d, %Y').to_s] = report.savings.to_f
        summary[:stocks][report.date.strftime('%B %d, %Y').to_s] = report.stocks.to_f
      end
      summary
    end
  end
end
