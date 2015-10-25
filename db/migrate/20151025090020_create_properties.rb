class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.decimal :monthly_rental_income
      t.decimal :down_payment_percent
      t.decimal :sale_price
      t.decimal :operating_expenses_percent
      t.decimal :vacancy_percent
      t.decimal :down_payment_percent
      t.decimal :loan_interest_percent
      t.integer :loan_length_years
      t.decimal :sales_commission_percent

      t.timestamps null: false
    end
  end
end
