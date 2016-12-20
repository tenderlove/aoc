INPUT = 3018458

class Elf < Struct.new(:left, :name, :presents)
  def steal
    self.presents += left.presents
    left.presents = 0

    puts "eliminating #{self.left.name}"
    self.left = self.left.left
  end
end

def build max
  elves = max.times.map { |i| Elf.new nil, i + 1, 1 }
  elves.each_with_index { |e, i| e.left = elves[i + 1] || elves.first }
  elves.first
end

head = build INPUT

puts "done building"

until head.presents == INPUT
  head.steal

  head = head.left
end

p head.name
