#banks = [0, 2, 7, 0]
banks = ARGF.read.split.map(&:to_i)
seen = []
loop do
  max = banks.max
  idx = banks.index banks.max
  banks[idx] = 0
  max.times do |i|
    i = (i + idx + 1) % banks.size
    banks[i] += 1
  end
  break if seen.include? banks
  seen << banks.dup
end
p seen.reverse.index banks
p seen.size
