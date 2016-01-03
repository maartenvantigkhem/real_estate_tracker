# == Schema Information
#
# Table name: properties
#
#  id                          :integer          not null, primary key
#  monthly_rental_income       :decimal(, )
#  down_payment_percent        :decimal(, )
#  sale_price                  :decimal(, )
#  operating_expenses_percent  :decimal(, )
#  vacancy_percent             :decimal(, )
#  loan_interest_percent       :decimal(, )
#  loan_length_years           :integer
#  sales_commission_percent    :decimal(, )
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  address                     :string
#  city                        :string
#  state                       :string
#  zip                         :string
#  posting_url                 :string
#  num_years_to_hold           :integer
#  rent_price_increase_percent :decimal(, )
#  tax_rate_percent            :decimal(, )
#

class Property < ActiveRecord::Base
  RESIDENTIAL_DEPRECIATION_YEARS = 27.5
  COMMERCIAL_DEPRECIATION_YEARS = 39
  CAP_GAIN_TAX_RATE_PERCENT = 15
  RECAPTURE_RATE = 0.33 # TODO: research this

  validates_presence_of :monthly_rental_income, :down_payment_percent, :sale_price, :operating_expenses_percent,
    :vacancy_percent, :loan_interest_percent, :loan_length_years, :sales_commission_percent, :num_years_to_hold,
    :rent_price_increase_percent, :tax_rate_percent

  def after_tax_cash_flow(year)
    after_tax_income(year) + depreciation - principal(year)
  end

  def after_tax_income(year)
    pre_tax_income(year) - taxes(year)
  end

  def after_tax_proceeds
    new_sale_price - sales_commission - cap_gain_tax - recapture - mortgage_balance
  end

  def annual_income
    monthly_rental_income * 12 
  end

  def cap_gain_tax
    (new_sale_price - sales_commission - sale_price) * CAP_GAIN_TAX_RATE_PERCENT / 100
  end

  def cap_rate(year)
    noi(year) / sale_price
  end

  # TODO: rename sale_price to purchase_price
  def cash_on_cash(year)
    after_tax_cash_flow(year) / down_payment.to_f
  end

  def depreciable_assets_cost
    # TODO: make land and assets separate
    sale_price
  end

  def depreciation
    depreciable_assets_cost/ RESIDENTIAL_DEPRECIATION_YEARS
  end

  def down_payment
    sale_price * (down_payment_percent.to_f / 100)
  end

  def full_address
    address + ', ' + city + ', ' + state + ', ' + zip
  end

  def gross_income(year)
    return annual_income if year == 1
    return gross_income(year - 1) * (1 + (rent_price_increase_percent.to_f / 100))
  end

  def gross_rent_multiplier
    sale_price / gross_income(1)
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

  def money_loaned
    sale_price - down_payment
  end

  def mortgage_balance
    money_loaned - principal(num_years_to_hold)
  end

  # TODO: rename me to sale_price once sale_price is renamed to purchase price
  def new_sale_price 
    noi(num_years_to_hold + 1) / cap_rate(num_years_to_hold + 1)
  end

  def noi(year)
    gross_income(year) - vacancy(year) - operating_expenses(year)
  end

  def operating_expenses(year)
    gross_income(year) * (operating_expenses_percent / 100)
  end

  def pre_tax_income(year)
    noi(year) - depreciation - interest_expense(year)
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

  def recapture
    depreciation * num_years_to_hold * RECAPTURE_RATE
  end

  def sales_commission
    new_sale_price * sales_commission_percent / 100
  end

  def taxes(year)
    pre_tax_income(year) * (tax_rate_percent.to_f / 100)
  end

  def vacancy(year)
    gross_income(year) * (vacancy_percent / 100)
  end

  def irr_for_prop
    cash_flows = []

    # First cash flow is just the down payment
    cash_flows << -down_payment

    # Use all of the A/T cash flows until you sell the house
    (1..(num_years_to_hold - 1)).each do |year|
      cash_flows << after_tax_cash_flow(year)
    end

    cash_flows << after_tax_cash_flow(num_years_to_hold) + after_tax_proceeds

    irr(0.0, 100.0, cash_flows)
  end

  def irr(min_rate, max_rate, amounts)
    range = max_rate - min_rate
    return 0 if range <= Float::EPSILON * 2

    rate = range.fdiv(2) + min_rate
    present_value = present_value_of_series(rate, amounts)

    if present_value > 0
      irr(rate, max_rate, amounts)
    elsif present_value < -1
      irr(min_rate, rate, amounts)
    else
      rate
    end
  end

  def present_value_of_series(rate, amounts)
    amounts.each_with_index.reduce(0) do |sum, (amount, index)|
      sum + amount / (rate + 1)**index
    end
  end


end
