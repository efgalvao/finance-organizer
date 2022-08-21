module Account
  class AccountPresenter < Oprah::Presenter
    presents_one :user
    presents_many :treasuries

    def account_total
      (sum_current_treasuries + sum_current_total_stocks + balance_cents / 100.0)
    end

    def current_value_in_treasuries
      sum_current_treasuries
    end

    def current_value_in_stocks
      sum_current_total_stocks
    end

    def total_invested
      sum_invested_treasuries + sum_invested_stocks
    end

    def updated_invested_value
      sum_current_treasuries + sum_current_total_stocks
    end

    def stocks_count
      stocks.size
    end

    def treasuries_count
      not_released_treasuries.size
    end

    def current_report_date
      I18n.l(current_report.date, format: :long)
    end

    def current_report
      date = DateTime.current
      report = reports.find_by(date: date.beginning_of_month...date.end_of_month)

      report = create_current_report if report.nil?
      report
    end

    def create_current_report
      reports.create!(account_report_params)
    end

    def account_report_params
      {
        date: DateTime.current,
        incomes_cents: incomes.cents,
        expenses_cents: expenses.cents,
        invested_cents: invested.cents,
        dividends_cents: dividend.cents,
        final_cents: total_balance.cents
      }
    end

    def incomes(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'income').sum(:value_cents))
    end

    def expenses(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'expense').sum(:value_cents))
    end

    def card_expenses(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'expense').sum(:value_cents))
    end

    def invested(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'investment').sum(:value_cents))
    end

    def total_balance(date = DateTime.current)
      Money.new(incomes(date) - expenses(date) - invested(date))
    end

    # VERIFY
    def past_reports
      past_reports = []
      (1..6).each do |n|
        date = DateTime.current - n.month
        report = reports.find_by(date: date.beginning_of_month...date.end_of_month)

        report = create_report(date) if report.nil?
        past_reports << report
      end
      past_reports
    end

    def semester_summary
      current_report
      Statements::CreateAccountSummary.call(semester_reports)
    end

    def semester_reports
      reports.where('date > ?', Time.zone.today - 6.months).order(date: :desc)
    end

    def last_semester_total_dividends_received
      grouped_dividends = {}
      semester_reports.each do |report|
        grouped_dividends[report.date.strftime('%B %d, %Y').to_s] = report.dividends.to_f
      end
      grouped_dividends
    end

    def create_report(date = DateTime.current)
      reports.create!(date: date, incomes_cents: 0, expenses_cents: 0,
                      invested_cents: 0, final_cents: 0)
    end

    def sum_current_treasuries
      not_released_treasuries.inject(0) { |sum, elem| sum + elem.current_value_cents } / 100
    end

    def sum_invested_treasuries
      not_released_treasuries.inject(0) { |sum, elem| sum + elem.invested_value_cents } / 100
    end

    def sum_invested_stocks
      stocks.inject(0) { |sum, elem| sum + elem.invested_value_cents } / 100
    end

    def sum_current_total_stocks
      stocks.inject(0) { |sum, elem| sum + elem.current_total_value_cents } / 100
    end
  end
end
