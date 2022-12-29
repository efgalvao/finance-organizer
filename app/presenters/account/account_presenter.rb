module Account
  class AccountPresenter < SimpleDelegator
    def account_total
      Money.new(sum_current_treasuries + sum_current_total_stocks + balance)
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
      Money.new(sum_current_treasuries + sum_current_total_stocks)
    end

    def stocks_count
      ordered_stocks.size
    end

    def treasuries_count
      ordered_not_released_treasuries.size
    end

    def current_report_date
      I18n.l(current_report.date, format: :long)
    end

    def current_report
      @current_report ||= begin
        report = reports.find_by('date >= ? AND date <= ?', DateTime.current.beginning_of_month,
                                 DateTime.current.end_of_month)

        report = create_current_report if report.blank?
        report
      end
    end

    def create_current_report
      ::AccountReport::CreateAccountReport.call(account_id: id)
    end

    def past_reports
      @past_reports ||= semester_reports.slice(1, 6)
    end

    def semester_summary
      current_report
      Statements::CreateAccountSummary.call(semester_reports)
    end

    def semester_reports
      @semester_reports ||= reports.order(date: :desc).limit(7)
    end

    def last_semester_total_dividends_received
      grouped_dividends = {}
      semester_reports.each do |report|
        grouped_dividends[report.date.strftime('%B %d, %Y').to_s] = report.dividends.to_f
      end
      grouped_dividends
    end

    def sum_current_treasuries
      # current_sum = ordered_not_released_treasuries.inject(0) do |sum, elem|
      #   sum + elem.current_value_cents
      # end
      @sum_current_treasuries ||= Money.new(ordered_not_released_treasuries.sum(&:current_value_cents))
    end

    def sum_invested_treasuries
      # treasuries_sum = ordered_not_released_treasuries.inject(0) do |sum, elem|
      #   sum + elem.invested_value_cents
      # end
      @sum_invested_treasuries ||= Money.new(ordered_not_released_treasuries.sum(&:invested_value_cents))
    end

    def sum_invested_stocks
      # sum_invested = stocks.inject(0) do |sum, elem|
      #   sum + elem.invested_value_cents
      # end
      @sum_invested_stocks ||= Money.new(stocks.sum(&:invested_value_cents))
    end

    def sum_current_total_stocks
      # current_sum = stocks.inject(0) do |sum, elem|
      #   sum + elem.current_total_value_cents
      # end
      @sum_current_total_stocks ||= Money.new(stocks.sum(&:current_total_value_cents))
    end

    def ordered_stocks
      @ordered_stocks ||= stocks.order(ticker: :asc)
    end

    def ordered_not_released_treasuries
      @ordered_not_released_treasuries ||= treasuries.where(released_at: nil).order(name: :asc).map do |treasury|
        Investments::Treasury::TreasuryPresenter.new(treasury)
      end
    end
  end
end
