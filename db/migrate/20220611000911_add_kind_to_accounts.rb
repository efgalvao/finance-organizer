class AddKindToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :kind, :integer, default: 0, null: false
  end
end
