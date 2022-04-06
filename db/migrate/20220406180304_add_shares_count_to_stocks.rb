class AddSharesCountToStocks < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :shares_count, :integer
  end
end
