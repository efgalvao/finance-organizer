class AddReleaseToTreasuries < ActiveRecord::Migration[6.1]
  def change
    add_monetize :treasuries, :released_value, default: 0, currency: { present: false }
    add_column :treasuries, :released_at, :datetime
  end
end
