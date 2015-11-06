class AddTaxRatePercentToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :tax_rate_percent, :decimal
  end
end
