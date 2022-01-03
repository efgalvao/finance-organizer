class RemovePolymorphicFromBalances < ActiveRecord::Migration[6.1]
  def change
    remove_reference :balances, :balanceable, polymorphic: true, index: true
  end
end
