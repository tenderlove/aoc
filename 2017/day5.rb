jump_list = ARGF.readlines.map(&:to_i)
# jump_list = [0, 3, 0, 1, -3]
pc        = 0
steps     = 0

begin
  loop do
    old_pc = pc
    pc += jump_list.fetch(pc)
    if jump_list[old_pc] >= 3
      jump_list[old_pc] -= 1
    else
      jump_list[old_pc] += 1
    end
    steps += 1
  end
rescue IndexError
  p steps
end
