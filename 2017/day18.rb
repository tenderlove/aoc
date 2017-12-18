puts "#" * 90
p Time.now

insns = DATA.each_line.map(&:split)
insns = File.read("input.txt").each_line.map(&:split)

def get_arg registers, arg
  if arg =~ /^[-\d]+/
    arg.to_i
  else
    registers[arg]
  end
end

def run_it insns, registers, output, input, program
  pc   = 0
  sent = 0

  loop do
    break unless insns[pc]

    args    = insns[pc].drop(1)
    op, op1 = *args

    case insns[pc].first
    when "snd"
      sent += 1
      output << get_arg(registers, op)
    when "set"
      registers[op]  = get_arg(registers, op1)
    when "add"
      registers[op] += get_arg(registers, op1)
    when "mul"
      registers[op] *= get_arg(registers, op1)
    when "mod"
      registers[op] %= get_arg(registers, op1)
    when "rcv"
      registers[op] = input.pop
    when "jgz"
      if get_arg(registers, op) > 0
        pc += get_arg(registers, op1)
        next
      end
    else
      raise insns[pc].first
    end

    pc += 1
  end
ensure
  p [program, registers, sent]
end

a_input = Queue.new
b_input = Queue.new

j = Thread.new do
  registers = Hash.new(0)
  registers["p"] = 1
  run_it insns, registers, b_input, a_input, 1
end

i = Thread.new do
  registers = Hash.new(0)
  registers["p"] = 0
  run_it insns, registers, a_input, b_input, 0
end

i.join
j.join

__END__
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
