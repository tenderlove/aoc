spreadsheet = Enum.map IO.stream(:stdio, :line), fn line ->
  with row = Enum.sort Enum.map String.split(line, ~r{[\t\n]}, trim: true), &String.to_integer/1
  do
    with [ small | _ ] = row,
         [ large | _ ] = Enum.reverse row
    do
      large - small
    end
  end
end
IO.inspect Enum.sum spreadsheet
