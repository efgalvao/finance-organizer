module Statements
  class CreateIncomesExpenses
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def perform
      mount_income_expense
    end

    private

    def mount_income_expense
      table = {}
      (0..6).each do |i|
        date = Time.zone.today - i.month
        data = { incomes: 0, expenses: 0, total: 0 }
        user.accounts.map do |account|
          data[:incomes] += account.incomes(date)
          data[:expenses] += account.expenses(date)
          data[:total] += account.total_balance(date)
        end
        table[date.strftime('%B, %Y').to_s] = data
      end
      table
    end
  end
end
