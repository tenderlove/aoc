p Time.now

list   = 256.times.to_a
inputs = ["18,1,0,161,255,137,254,252,14,95,165,33,181,168,2,188"].map(&:to_s).join.bytes + [17, 31, 73, 47, 23]

rotate = 0
skip_size = 0
rotated = 0

def reverse list, rotate, size
  rev = list.rotate(rotate)[0, size]
  rev.reverse + list.rotate(rotate)[size..-1]
end

64.times do
inputs.each do |input|
  list = reverse list, rotate, input
  rotated += rotate
  rotate = input + skip_size
  skip_size += 1
end
end

dense = list.rotate(-rotated).each_slice(16).map do |chunk|
  chunk.inject(0) { |a, x| a ^ x }
end

p dense.map { |i|
  z = i.to_s(16)
  if z.length == 1
    "0#{z}"
  else
    z
  end
}.join
p dense.length
