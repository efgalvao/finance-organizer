class ChangeStocks < ActiveRecord::Migration[6.1]
  def change
    add_monetize :stocks, :invested_value, default: 0, currency: { present: false }
    add_monetize :stocks, :current_value, default: 0, currency: { present: false }
    add_monetize :stocks, :current_total_value, default: 0, currency: { present: false }
    rename_column :stocks, :name, :ticker
    add_column :stocks, :shares_total, :integer, default: 0
  end
end
