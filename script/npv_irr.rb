# compute NPV given cash flows and IRR
def npv (cf, irr)
  (0...cf.length).inject(0) { |npv, t| npv + (cf[t]/(1+irr)**t) }
end

# compute derivative of the NPV with respect to IRR
# d(C_t * (1+IRR)**t)/dIRR = -t * C_t / (1+IRR)**(t-1)
#
def dnpv (cf, irr)
  (1...cf.length).inject(0) { |npv, t| npv - (t*cf[t]/
(1+irr)**(t-1)) }
end

# solve for IRR with newton's method: x_{n+1} = x_n - f(x) / f'(x)
def irr (cf)
  irr = 0.5
  it = 0
  begin
    begin
      oirr = irr
      irr -= npv(cf, irr) / dnpv(cf, irr)
      it += 1
      return nil if it > 50
    end until (irr - oirr).abs < 0.0001
  rescue ZeroDivisionError
    return nil
  end
  irr
end

puts irr([-100,30,35,40,45])
puts irr([-1.0,1.0])
puts irr([-1000.0,999.99])
puts irr([-1000.0,999.0])
puts irr([100,10,10,10])
puts irr([0.0])
puts irr([])