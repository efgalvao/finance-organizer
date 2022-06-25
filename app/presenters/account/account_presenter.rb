module Account
  class AccountPresenter < Oprah::Presenter
    presents_one :user
    # def except_card_accounts
    #   accounts.where.not(name: 'card').order(:name)
    # end

    def account_total
      total = (treasuries.sum(:current_value_cents) + stocks.sum(:current_total_value_cents)) + balance_cents
      total / 100.0
    end

    def current_value_in_treasuries
      treasuries.sum(:current_value_cents) / 100.0
    end

    def current_value_in_stocks
      stocks.sum(:current_total_value_cents) / 100.0
    end

    def total_invested
      total = (treasuries.sum(:invested_value_cents) + stocks.sum(:invested_value_cents))
      total / 100.0
    end

    def updated_invested_value
      total = treasuries.sum(:current_value_cents) + stocks.sum(:current_total_value_cents)
      total / 100.0
    end

    def stocks_count
      stocks.size
    end

    def treasuries_count
      treasuries.size
    end

    #------

    def current_report_date
      I18n.l(current_report.date)
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
  end
end
