namespace :maintenance do
  desc 'remove records older than 1 year'
  task :remove_old_records do
    query = "SELECT * FROM transactions WHERE (date <= '2022-02-27')"
    response = Account::Transaction.find_by_sql(query)
    Account::AccountReport.where(date) (call 'Account::AccountReport.connection' to establish a connection),
    Investments::Stock::Dividend (call 'Investments::Stock::Dividend.connection' to establish a connection),
    Investments::Treasury::Negotiation (call 'Investments::Treasury::Negotiation.connection' to establish a connection),
    Investments::Treasury::Position (call 'Investments::Treasury::Position.connection' to establish a connection),
    Investments::Stock::Price (call 'Investments::Stock::Price.connection' to establish a connection),
    Account::Transaction (call 'Account::Transaction.connection' to establish a connection),
    Transference (call 'Transference.connection' to establish a connection),
    UserReport (call 'UserReport.connection' to establish a connection),

  end

end
