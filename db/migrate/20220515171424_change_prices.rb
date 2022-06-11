class ChangePrices < ActiveRecord::Migration[6.1]
  def change
    rename_column :prices, :price_cents, :value_cents
  end
end
