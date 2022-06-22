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
      report
    end

    def create_current_report
      reports.create!(date: Date.current, incomes_cents: incomes.cents, expenses_cents: expenses.cents,
                      invested_cents: invested.cents, final_cents: total_balance.cents)
    end
  end
end
