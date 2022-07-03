module Account
  class AccountPresenter < Oprah::Presenter
    presents_one :user
    presents_many :treasuries

    def account_total
      total = (sum_current_value + stocks.sum(:current_total_value_cents) + balance_cents)
      total / 100.0
    end

    def current_value_in_treasuries
      sum_current_value / 100.0
    end

    def current_value_in_stocks
      stocks.sum(:current_total_value_cents) / 100.0
    end

    def total_invested
      total = sum_invested_value + stocks.sum(:invested_value_cents)
      total / 100.0
    end

    def updated_invested_value
      total = sum_current_value + stocks.sum(:current_total_value_cents)
      total / 100.0
    end

    def stocks_count
      stocks.size
    end

    def treasuries_count
      treasuries.size
    end

    def current_report_date
      I18n.l(current_report.date, format: :long)
    end

    def current_report
      date = DateTime.current
      report = reports.find_by(date: date.beginning_of_month...date.end_of_month)

      report = create_current_report if report.nil?
      update_account_report(report)
      report
    end

    def create_current_report
      reports.create!(date: Date.current, incomes_cents: incomes.cents, expenses_cents: expenses.cents,
                      invested_cents: invested.cents, final_cents: total_balance.cents)
    end

    def update_account_report(report)
      report.date = DateTime.current
      report.incomes_cents = incomes.cents
      report.expenses_cents = expenses.cents
      report.invested_cents = invested.cents
      report.final_cents = total_balance.cents
      report
    end

    def incomes(date = DateTime.current)
      Money.new(transactions.where(date: date.beginning_of_month...date.end_of_month,
                                   kind: 'income').sum(:value_cents))
    end

    def expenses(date = DateTime.current)
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
      create_report if reports.empty? || reports.last.date.month != DateTime.current.month
      Statements::CreateAccountSummary.call(semester_reports)
    end

    def semester_reports
      reports.where('date > ?', Time.zone.today - 6.months).order(date: :desc)
    end

    private

    def create_report(date)
      reports.create!(date: date, incomes_cents: 0, expenses_cents: 0,
                      invested_cents: 0, final_cents: 0)
    end

    def sum_current_value
      treasuries.inject(0) { |sum, elem| sum + elem.current_value_cents }
    end

    def sum_invested_value
      treasuries.inject(0) { |sum, elem| sum + elem.invested_value_cents }
    end
  end
end
