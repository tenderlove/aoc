INPUT = 3018458

class Elf < Struct.new(:left, :name, :presents)
  include Enumerable

  def steal
    raise if presents == 0
    self.presents += left.presents
    left.presents = 0
  end

  def each
    yield self
    head = self
    while head.left != self
      yield head.left
      head = head.left
    end
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

  while head.left.presents == 0
    puts "eliminating #{head.left.name}"
    head.left = head.left.left
  end
  head = head.left
end

p head.name
