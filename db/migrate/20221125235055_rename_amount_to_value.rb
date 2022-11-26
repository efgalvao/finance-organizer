class RenameAmountToValue < ActiveRecord::Migration[6.1]
  def change
    rename_column :transferences, :amount_cents, :value_cents
  end
end
