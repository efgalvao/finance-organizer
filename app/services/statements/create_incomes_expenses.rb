module Statements
  class CreateIncomesExpenses
    def initialize(user)
      @user = user
    end

    def perform
      get_reports
    end

    private

    attr_reader :user

    def get_reports(date = DateTime.current)
      table = {}
      (1..6).each do |i|
        date = Time.zone.today - i.month
        report = user.reports.find_by(date: date.beginning_of_month...date.end_of_month)
        report = create_report(date) if report.nil?
        table[date.strftime('%B, %Y').to_s] = report
      end
      table
    end

    def create_report(date)
      user.reports.create!(date: date, incomes_cents: 0, expenses_cents: 0,
                           invested_cents: 0, final_cents: 0)
    end
  end
end
