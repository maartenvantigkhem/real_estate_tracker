# == Schema Information
#
# Table name: properties
#
#  id                         :integer          not null, primary key
#  monthly_rental_income      :decimal(, )
#  down_payment_percent       :decimal(, )
#  sale_price                 :decimal(, )
#  operating_expenses_percent :decimal(, )
#  vacancy_percent            :decimal(, )
#  loan_interest_percent      :decimal(, )
#  loan_length_years          :integer
#  sales_commission_percent   :decimal(, )
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  address                    :string
#  city                       :string
#  state                      :string
#  zip                        :string
#

class Property < ActiveRecord::Base

  # TODO: make these inputs
  RENT_PRICE_INCREASE_PERCENT = 3
  NUM_YEARS_TO_HOLD = 5
  RESIDENTIAL_DEPRECIATION_YEARS = 27.5
  COMMERCIAL_DEPRECIATION_YEARS = 39
  TAX_RATE_PERCENT = 33

  def noi(year)
    gross_income(year) - vacancy(year) - operating_expenses(year)
  end

  def vacancy(year)
    gross_income(year) * (vacancy_percent / 100)
  end

  def annual_income
    monthly_rental_income * 12 
  end

  def cap_rate(year)
    noi(year) / sale_price
  end

  def down_payment
    sale_price * (down_payment_percent / 100)
  end

  def gross_income(year)
    return annual_income if year == 1
    return gross_income(year - 1) * (1 + (RENT_PRICE_INCREASE_PERCENT / 100))
  end
  # TODO: rename sale_price to purchase_price
  def cash_on_cash(year)
    after_tax_cash_flow(year) / down_payment
  end

  def depreciation
    depreciable_assets_cost/ RESIDENTIAL_DEPRECIATION_YEARS
  end

  def depreciable_assets_cost
    # TODO: make land and assets separate
    sale_price
  end

  def gross_rent_multiplier
    sale_price / gross_income(1)
  end

  def pre_tax_income(year)
    noi(year) - depreciation - interest_expense(year)
  end

  def estimated_sale_price(year)
    noi(year) / cap_rate(year)
  end

  def operating_expenses(year)
    gross_income(year) * (operating_expenses_percent / 100)
  end

  def full_address
    address + ', ' + city + ', ' + state + ', ' + zip
  end
end
