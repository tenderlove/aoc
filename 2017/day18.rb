puts "#" * 90
p Time.now

a = 0
b = 0

insns = DATA.each_line.map(&:split)
insns = File.read("input.txt").each_line.map(&:split)

rcv = nil

def get_arg registers, arg
  if arg =~ /^[-\d]+/
    arg.to_i
  else
    registers[arg]
  end
end

def run_it insns, registers, output, input
  pc = 0
  sent = 0
  trap("INFO") { p SENT: sent }

  loop do
    break unless insns[pc]

    args = insns[pc].drop(1)
    case insns[pc].first
    when "snd"
      sent += 1
      output << get_arg(registers, args.first)
    when "set"
      registers[args.first] = get_arg registers, args.last
    when "add"
      registers[args.first] += get_arg(registers, args.last)
    when "mul"
      registers[args.first] *= get_arg(registers, args.last)
    when "mod"
      registers[args.first] %= get_arg(registers, args.last)
    when "rcv"
      v = input.pop
      p GOT: v
      registers[args.first] = v
    when "jgz"
      if get_arg(registers, args.first) > 0
        pc += get_arg(registers, args.last)
        next
      end
    else
      raise insns[pc].first
    end

    pc += 1
  end
ensure
  p registers
  p sent
end

a_input = Queue.new
b_input = Queue.new

j = Thread.new do
  registers = Hash.new(0)
  registers["p"] = 1
  run_it insns, registers, b_input, a_input
end

i = Thread.new do
  registers = Hash.new(0)
  registers["p"] = 0
  run_it insns, registers, a_input, b_input
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
