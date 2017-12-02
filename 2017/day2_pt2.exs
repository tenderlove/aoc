spreadsheet = Enum.map IO.stream(:stdio, :line), fn line ->
  with row = Enum.sort Enum.map String.split(line, ~r{[\t\n]}, trim: true), &String.to_integer/1
  do
    num = fn [head | rest], func ->
      fn nil -> func.(rest, func)
         a   -> div a, head
      end.(Enum.find rest, &rem(&1, head) == 0)
    end
    num.(row, num)
  end
end
IO.inspect Enum.sum spreadsheet
