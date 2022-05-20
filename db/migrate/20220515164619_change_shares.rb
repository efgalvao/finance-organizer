class ChangeShares < ActiveRecord::Migration[6.1]
  def change
    rename_column :shares, :aquisition_date, :date
    rename_column :shares, :aquisition_value_cents, :invested_cents
    add_column :shares, :quantity, :integer, default: 0, null: false
  end
end
