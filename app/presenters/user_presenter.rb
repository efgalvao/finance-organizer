class UserPresenter < SimpleDelegator
  def memoized_accounts
    @memoized_accounts ||= present_accounts(accounts: accounts.includes([:stocks]).order('name'))
  end

  def except_card_accounts
    @except_card_accounts ||= memoized_accounts.reject { |account| account[:kind] == 'card' }
  end

  def card_accounts
    @card_accounts ||= memoized_accounts.select { |account| account[:kind] == 'card' }
  end

  def formated_date
    @formated_date ||= I18n.l(updated_current_month_report.date)
  end

  def updated_current_month_report
    if current_month_user_report.nil?
      create_report
    else
      update_current_user_report
    end
    current_month_user_report
  end

  def semester_summary
    create_report if current_month_user_report.date.month != DateTime.current.month
    Statements::CreateUserSummary.call(reports: semester_reports)
  end

  def last_semester_total_dividends
    grouped_dividends = {}
    semester_reports.each do |report|
      grouped_dividends[report.date.strftime('%B %Y').to_s] = report.dividends.to_f
    end
    grouped_dividends
  end

  def incomes_expenses_report
    Statements::CreateIncomesExpenses.call(user: self)
  end

  private

  def present_accounts(accounts:)
    accounts.map do |account|
      Account::AccountPresenter.new(account)
    end
  end

  def current_month_user_report
    @current_month_user_report ||= reports.find_by('date >= ? AND date <= ?', DateTime.current.beginning_of_month,
                                                   DateTime.current.end_of_month)
  end

  def update_current_user_report
    UserReports::Commands::UpdateUserReport.call(report: current_month_user_report,
                                                 params: updated_report_params)
  end

  def updated_report_params
    @updated_report_params ||= begin
      report = { date: DateTime.current, total_cents: 0, savings_cents: 0, stocks_cents: 0,
                 incomes_cents: 0, expenses_cents: 0, card_expenses_cents: 0, invested_cents: 0,
                 final_cents: 0, dividends_cents: 0 }

      except_card_accounts.each do |account|
        report[:total_cents] += account.account_total.cents
        report[:savings_cents] += account.balance_cents
        report[:stocks_cents] += account.updated_invested_value.cents
        report[:incomes_cents] += account.current_report.incomes_cents
        report[:expenses_cents] += account.current_report.expenses_cents
        report[:invested_cents] += account.current_report.invested_cents
        report[:final_cents] += account.current_report.final_cents
        report[:dividends_cents] += account.current_report.dividends_cents
      end

      card_accounts.each do |account|
        report[:card_expenses_cents] += account.current_report.expenses_cents
      end

      report
    end
  end

  def semester_reports
    @semester_reports ||= reports.where('date > ?', Time.zone.today - 6.months).order(date: :asc)
  end

  def create_report
    UserReports::Commands::CreateUserReport.call(user_id: id, params: updated_report_params)
  end
end
