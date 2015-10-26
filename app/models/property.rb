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
    sale_price * (down_payment_percent.to_f / 100)
  end

  def gross_income(year)
    return annual_income if year == 1
    return gross_income(year - 1) * (1 + (RENT_PRICE_INCREASE_PERCENT.to_f / 100))
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

  def interest_expense(year)
    balance = sale_price - down_payment
    monthly_rate = (loan_interest_percent / 100) / 12.to_f
    periods = loan_length_years * 12
    end_period = year * 12
    start_period = end_period - 11

    term = (1 + monthly_rate) ** periods
    
    monthly_payment = balance * (monthly_rate * term / (term - 1))
    
    current_period = 1
    total_interest = 0
    while balance > 0 && current_period <= (year * 12)
      interest_payment = balance * monthly_rate
      
      if current_period >= start_period && current_period <= end_period
        total_interest += interest_payment
      end

      principal_payment = monthly_payment - interest_payment
      balance = balance - principal_payment
      current_period += 1
    end

    total_interest
  end

  def pre_tax_income(year)
    noi(year) - depreciation - interest_expense(year)
  end

  def taxes(year)
    pre_tax_income(year) * (TAX_RATE_PERCENT.to_f / 100)
  end

  def after_tax_income(year)
    pre_tax_income(year) - taxes(year)
  end

  def principal(year)
    balance = sale_price - down_payment
    monthly_rate = (loan_interest_percent / 100) / 12.to_f
    periods = loan_length_years * 12
    end_period = year * 12
    start_period = end_period - 11

    term = (1 + monthly_rate) ** periods
    
    monthly_payment = balance * (monthly_rate * term / (term - 1))
    
    current_period = 1
    total_principal = 0
    while balance > 0 && current_period <= (year * 12)
      interest_payment = balance * monthly_rate
      
      principal_payment = monthly_payment - interest_payment
      if current_period >= start_period && current_period <= end_period
        total_principal += principal_payment
      end
      balance = balance - principal_payment
      current_period += 1
    end

    total_principal
  end

  def after_tax_cash_flow(year)
    after_tax_income(year) + depreciation - principal(year)
  end

  def cash_on_cash(year)
    puts 'after_tax_cash_flow: ' + after_tax_cash_flow(year).to_s
    puts 'down_payment: ' + down_payment.to_s
    
    after_tax_cash_flow(year) / down_payment.to_f
  end


end
