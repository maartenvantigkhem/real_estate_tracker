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
end
