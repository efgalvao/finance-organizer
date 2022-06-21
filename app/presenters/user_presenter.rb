class UserPresenter < Oprah::Presenter
  presents_many :accounts

  def except_card_accounts
    accounts = []
    self.accounts.select do |account|
      account[:kind] != 'card'
    end
  end

  def formated_date
    I18n.l(current_month_report.date)
  end

  def current_month_report
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

  def update_current_user_report
    user_report = current_month_report

    user_report.date = DateTime.current
    user_report.total = total_amount
    user_report.savings = total_balance
    user_report.stocks = total_invested
    user_report.save
  end

  private

  def semester_reports
    reports.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
  end

  def create_report
    reports.create(total: total_amount, savings: total_balance, stocks: total_in_stocks)
  end
end
