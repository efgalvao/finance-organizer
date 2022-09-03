class UserPresenter < SimpleDelegator
  def memoized_accounts
    @memoized_accounts ||= accounts.includes([:stocks]).order('name')
  end

  def except_card_accounts
    @except_card_accounts ||= begin
      accounts = memoized_accounts.reject { |account| account[:kind] == 'card' }
      present_accounts(accounts: accounts)
    end
  end

  def card_accounts
    @card_accounts ||= begin
      accounts = memoized_accounts.select { |account| account[:kind] == 'card' }
      present_accounts(accounts: accounts)
    end
  end

  def formated_date
    I18n.l(updated_current_month_report.date)
  end

  def updated_current_month_report
    create_report if current_month_user_report.nil?
    update_current_user_report
    current_month_user_report
  end

  def total_amount
    total = 0
    except_card_accounts.each do |account|
      account = Account::AccountPresenter.new(account)
      total += account.account_total
    end
    total
  end

  def total_balance
    total = 0
    except_card_accounts.each do |account|
      account = Account::AccountPresenter.new(account)
      total += account.balance
    end
    total
  end

  def total_invested
    total = 0
    except_card_accounts.each do |account|
      account = Account::AccountPresenter.new(account)
      total += account.updated_invested_value
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
    semester_reports.each do |report|
      grouped_dividends[report.date.strftime('%B %Y').to_s] = report.dividends.to_f
    end
    grouped_dividends
  end

  def incomes_expenses_report
    Statements::CreateIncomesExpenses.new(self).perform
  end

  private

  def present_accounts(accounts:)
    accounts.map do |account|
      Account::AccountPresenter.new(account)
    end
  end

  def current_month_user_report
    reports.order(date: :desc).first
  end

  def update_current_user_report
    user_report = current_month_user_report

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
    report.card_expenses_cents = 0
    report.invested_cents = 0
    report.final_cents = 0
    except_card_accounts.each do |account|
      account = Account::AccountPresenter.new(account)
      report.incomes_cents += account.incomes.cents
      report.expenses_cents += account.expenses.cents
      report.invested_cents += account.invested.cents
      report.final_cents += account.total_balance.cents
    end
    card_accounts.each do |account|
      account = Account::AccountPresenter.new(account)
      report.card_expenses_cents += account.expenses.cents
    end
    report.save
    report
  end

  def semester_reports
    reports.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
  end

  def create_report
    UserReports::Commands::CreateUserReport.call(user_id: id, params: report_params)
    # reports.create(date: Date.current, total: total_amount, savings: total_balance, stocks: total_invested)
  end
end
