INPUT = 3018458

class Elf
  include Enumerable

  attr_accessor :name, :presents, :ary

  def initialize name, presents
    @ary       = nil
    @name      = name
    @left_idx  = name
    @presents  = presents
  end

  def steal me, ary
    target_idx = me + (ary.length / 2)
    if target_idx >= ary.length
      target_idx -= ary.length
    end
    @presents += ary.delete_at(target_idx).presents
  end
end

def build max
  max.times.map { |i| Elf.new i + 1, 1 }
end

elves = build INPUT

puts "done building"
GC.disable

idx = 0
until elves.length == 1
  elves[idx].steal(idx, elves)
  if( (idx + 1) >= elves.length)
    idx = 0
  else
    idx += 1
  end
  if elves.length % 10_000 == 0
    p elves.length => Time.now
  end
end

p elves.first.name
