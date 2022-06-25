class UserPresenter < Oprah::Presenter
  presents_many :accounts

  def except_card_accounts
    self.accounts.reject do |account|
      account[:kind] == 'card'
    end
  end

  def formated_date
    I18n.l(updated_current_month_report.date)
  end

  def updated_current_month_report
    update_current_user_report
    reports.current_month
  end

  def total_amount
    total = 0
    except_card_accounts.each do |account|
      total += account.account_total
    end
    total
  end

  def total_balance
    total = 0
    except_card_accounts.each do |account|
      total += account.balance
    end
    total
  end

  def total_invested
    total = 0
    except_card_accounts.each do |account|
      total += account.total_invested
    end
    total
  end

  # check below here

  def semester_summary
    create_report if reports.empty? || reports.last.date.month != DateTime.current.month
    update_current_user_report
    Statements::CreateUserSummary.new(semester_reports).perform
  end

  def last_semester_total_dividends
    grouped_dividends = {}
    accounts.each do |account|
      dividends = account.last_semester_total_dividends_received
      grouped_dividends = grouped_dividends.merge(dividends) { |_k, a_value, b_value| a_value + b_value }
    end
    grouped_dividends
  end

  def incomes_expenses_report
    Statements::CreateIncomesExpenses.new(self).perform
  end

  private

  def current_month_report
    reports.current_month
  end

  def update_current_user_report
    user_report = current_month_report

    user_report.date = DateTime.current
    user_report.total = total_amount
    user_report.savings = total_balance
    user_report.stocks = total_invested
    update_user_report(user_report)
    user_report.save
  end

  def update_user_report(report)
    report.incomes_cents = 0
    report.expenses_cents = 0
    report.invested_cents = 0
    report.final_cents = 0
    except_card_accounts.each do |account|
      report.incomes_cents += account.incomes.cents
      report.expenses_cents += account.expenses.cents
      report.invested_cents += account.invested.cents
      report.final_cents += account.total_balance.cents
      report.save
    end
    report
  end

  # check below here

  def semester_reports
    reports.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
  end

  def create_report
    reports.create(total: total_amount, savings: total_balance, stocks: total_in_stocks)
  end
end
