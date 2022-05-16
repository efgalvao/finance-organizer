class ChangeShares < ActiveRecord::Migration[6.1]
  def change
    rename_column :shares, :aquisition_date, :date
    rename_column :shares, :aquisition_value_cents, :invested_cents
  end
end
