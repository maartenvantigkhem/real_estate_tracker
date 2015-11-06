class AddMiscFieldsToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :num_years_to_hold, :integer
    add_column :properties, :rent_price_increase_percent, :decimal
  end
end
