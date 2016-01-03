# http://codereview.stackexchange.com/questions/92508/calculating-irr-internal-rate-of-return-in-ruby-using-recursion

def irr(min_rate, max_rate, amounts)
  range = max_rate - min_rate
  raise "No solution" if range <= Float::EPSILON * 2

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

puts irr(0.0, 100.0, [-140231.54, 30031.25, 35255.56, 40354.43, 45234.54])