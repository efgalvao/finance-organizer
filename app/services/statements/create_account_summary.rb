module Statements
  class CreateAccountSummary
    attr_reader :semester_reports

    def initialize(semester_reports)
      @semester_reports = semester_reports
    end

    def self.call(semester_reports)
      new(semester_reports).call
    end

    def call
      mount_summary
    end

    private

    def mount_summary
      summary = { income: {}, expense: {}, invested: {}, final: {}, dividends: {}, total_balance: {} }
      semester_reports.each do |report|
        summary[:income][report.date.strftime('%B, %Y').to_s] = report.incomes.to_f
        summary[:expense][report.date.strftime('%B, %Y').to_s] = report.expenses.to_f
        summary[:invested][report.date.strftime('%B, %Y').to_s] = report.invested.to_f
        summary[:final][report.date.strftime('%B %Y').to_s] = report.final.to_f
        summary[:dividends][report.date.strftime('%B, %Y').to_s] = report.dividends.to_f
        summary[:total_balance][report.updated_at.strftime('%B, %Y').to_s] = report.total_balance.to_f
      end
      summary
    end
  end
end
