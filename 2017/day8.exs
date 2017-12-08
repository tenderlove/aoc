defmodule Day8 do
  def doit reg, op, amt, regs do
    new_val = fn
      ("inc",  a, b) -> a + b
      ("dec",  a, b) -> a - b
    end.(op, regval(reg, regs), amt)
    Map.put regs, reg, new_val
  end

  def regval name, regs do
    fn 
      ({:ok, val}) -> val
      (:error)     -> 0
    end.(Map.fetch(regs, name))
  end

  def process_instruction { reg, op, amt, test_reg, test, test_amt }, regs do
    fn
      (">",  a, b, t, f) -> if a > b, do: t.(), else: f.()
      ("<",  a, b, t, f) -> if a < b, do: t.(), else: f.()
      (">=", a, b, t, f) -> if a >= b, do: t.(), else: f.()
      ("<=", a, b, t, f) -> if a <= b, do: t.(), else: f.()
      ("!=", a, b, t, f) -> if a != b, do: t.(), else: f.()
      ("==", a, b, t, f) -> if a == b, do: t.(), else: f.()
    end.(test, regval(test_reg, regs), test_amt, fn () -> doit(reg, op, amt, regs) end, fn () -> regs end)
  end

  def process_instructions [], regs, max do
    { regs, max }
  end

  def process_instructions [head | rest], regs, max do
    with new_regs = process_instruction head, regs do
      with max_reg = max_register(new_regs) do
        if max_reg > max, do: process_instructions(rest, new_regs, max_reg),
                          else: process_instructions(rest, new_regs, max)
      end
    end
  end

  def process_instructions instructions do
    process_instructions(instructions, %{}, 0)
  end

  def max_register regs do
    fn
      [head | _] -> head
      [] -> 0
    end.(Enum.reverse Enum.sort Map.values regs)
  end

  def read_instructions do
    Enum.map IO.stream(:stdio, :line), fn line ->
      [reg, op, amt, _, test_reg, test, test_amt] = String.split(line)
      {reg, op, String.to_integer(amt), test_reg, test, String.to_integer(test_amt)}
    end
  end
end

{ regs, max } = Day8.process_instructions Day8.read_instructions
IO.inspect Day8.max_register regs
IO.inspect max

