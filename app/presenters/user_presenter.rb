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

  # -----
  def updated_current_month_report
    create_report if current_month_user_report.nil?
    update_current_user_report
    current_month_user_report
  end

  # def total_amount
  #   total = 0
  #   except_card_accounts.each do |account|
  #     account = Account::AccountPresenter.new(account)
  #     total += account.account_total
  #   end
  #   total
  # end

  # def total_balance
  #   total = 0
  #   except_card_accounts.each do |account|
  #     account = Account::AccountPresenter.new(account)
  #     total += account.balance
  #   end
  #   total
  # end

  # def total_invested
  #   total = 0
  #   except_card_accounts.each do |account|
  #     account = Account::AccountPresenter.new(account)
  #     total += account.updated_invested_value
  #   end
  #   total
  # end

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

  # private

  def present_accounts(accounts:)
    accounts.map do |account|
      Account::AccountPresenter.new(account)
    end
  end

  def current_month_user_report
    reports.order(date: :desc).first
  end

  # AQUI - montando os params para fazer o update - criar um método para pegar informação de cada account e devolver já somado
  def update_current_user_report
    user_report = UserReports::Commands::UpdateUserReport.call(report: current_month_user_report,
                                                               params: update_user_report_params)
    # user_report = current_month_user_report

    # update_user_report(user_report)
    user_report.save
  end

  def update_user_report
    # params = {
    #   incomes_cents: 0,
    #   expenses_cents: 0,
    #   card_expenses_cents: 0,
    #   invested_cents: 0,
    #   final_cents: 0
    # }
    except_card_accounts.each do |account|
      # binding.pry
      # account = Account::AccountPresenter.new(account)
      # report.incomes_cents += account.incomes.cents
      # report.expenses_cents += account.expenses.cents
      # report.invested_cents += account.invested.cents
      # report.final_cents += account.total_balance.cents
    end
    card_accounts.each do |account|
      # account = Account::AccountPresenter.new(account)
      # report.card_expenses_cents += account.expenses.cents
    end
    # report.save
    # report
  end

  def update_user_report_params
    report = {
      total_cents: 0,
      savings_cents: 0,
      stocks_cents: 0,
      incomes_cents: 0,
      expenses_cents: 0,
      card_expenses_cents: 0,
      invested_cents: 0,
      final_cents: 0
    }
    except_card_accounts.each do |account|
      binding.pry

      # binding.pry
      # account = Account::AccountPresenter.new(account)
      report[:total_cents] += account.account_total
      report[:savings_cents] += account.balance
      report[:stocks_cents] += account.updated_invested_value
      report[:incomes_cents] += account.current_report.incomes_cents
      report[:expenses_cents] += account.current_report.expenses_cents
      report[:invested_cents] += account.current_report.invested_cents
      report[:final_cents] += account.current_report.final_cents
    end
    card_accounts.each do |account|
      # account = Account::AccountPresenter.new(account)
      report[:card_expenses_cents] += account.current_report.expenses_cents
    end

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
