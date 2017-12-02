defmodule Day1 do
  def make_circular list                    do { :circular, list, list } end
  def car { :circular, [ head | _ ], _ }    do head end
  def cdr { :circular, [ _ ], list }        do make_circular list end
  def cdr { :circular, [ _ | tail ], list } do { :circular, tail, list } end

  def find_sum [], _, _, acc do acc end

  def find_sum [ head | tail ], head, list, acc do
    find_sum tail, car(list), cdr(list), acc + head
  end

  def find_sum [ _ | tail ], _, list, acc do
    find_sum tail, car(list), cdr(list), acc
  end

  # Solution to the first problem
  def find_sum_first list do
    cmp = list |> make_circular |> cdr
    find_sum list, car(cmp), cdr(cmp), 0
  end

  # Solution to the second problem
  def find_sum_second list do
    cdrdown = fn
      (l, 0, _) -> l
      (l, i, f) -> f.(cdr(l), i - 1, f)
    end
    cmp = cdrdown.(make_circular(list), round(length(list) / 2), cdrdown)
    find_sum list, car(cmp), cdr(cmp), 0
  end
end

list = Enum.map String.codepoints("1122"), &String.to_integer/1
IO.puts Day1.find_sum_first list
IO.puts Day1.find_sum_second list
