spreadsheet = Enum.map IO.stream(:stdio, :line), fn line ->
  with row = Enum.map String.split(line, ~r{[\t\n]}, trim: true), &String.to_integer/1
  do
    row2 = Enum.map row, fn left -> [left, Enum.find(row, fn right -> left != right && rem(left, right) == 0 end)] end
    [l, r] = Enum.find row2, fn [ _, nil ] -> false
      [ _, _   ] -> true
    end
    round(l / r)
  end
end
IO.inspect Enum.sum spreadsheet
