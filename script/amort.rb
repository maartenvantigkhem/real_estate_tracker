def money (x)
  sprintf("%05.2f", x)
end

balance = 150000
annual_rate = 6.to_f * 0.01
monthly_rate = annual_rate / 12.to_f
loan_years = 15
n = loan_years*12

puts "Loan term (Number of payments) [#{n}]"
puts "Annual interest rate [#{annual_rate*100}]"
puts "Monthly interest rate [#{monthly_rate}]"
term = (1 + monthly_rate)**n
puts "Term = [#{term}]"

monthly_payment = balance * (monthly_rate * term / (term - 1))
puts "Monthly Payment = [#{money(monthly_payment)}]"

while (balance > 0)
  interest_payment = balance * monthly_rate
  principal_payment = monthly_payment - interest_payment
  balance = balance - principal_payment
  puts("Interest [$#{money(interest_payment)}], Principal [$#{money(principal_payment)}], Balance = [$#{money(balance)}]")
end