#!//usr/bin/env lua

function basic (mass)
  return math.floor(mass / 3) - 2
end

function fuel (total, mass)
  local input = basic(mass)
  if input <= 0 then
    return total
  else
    return fuel(total + input, input)
  end
end

a = 0
b = 0
for mass in io.lines() do
  a = a + basic(mass)
  b = b + fuel(0, mass)
end

print("A) required fuel = " .. a)
print("B) required fuel = " .. b)
