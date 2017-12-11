defmodule Day11 do
  def move { x, y, z }, "n"  do { x, y + 1, z - 1 } end
  def move { x, y, z }, "ne" do { x + 1, y, z - 1 } end
  def move { x, y, z }, "se" do { x + 1, y - 1, z } end
  def move { x, y, z }, "s"  do { x, y - 1, z + 1 } end
  def move { x, y, z }, "sw" do { x - 1, y, z + 1 } end
  def move { x, y, z }, "nw" do { x - 1, y + 1, z } end

  def distance { a_x, a_y, a_z }, { b_x, b_y, b_z } do
    (abs(a_x - b_x) + abs(a_y - b_y) + abs(a_z - b_z)) / 2
  end
end

origin = { 0, 0, 0 }
{ :ok, data } = File.read "input.txt"
list = String.split(data, ",", trim: true)

{ md, to } = List.foldl list, { 0, origin }, fn
  (x, { max_dist, from }) ->
    with point = Day11.move(from, x)
    do
      if (max_dist < Day11.distance(origin, point)),
      do: { Day11.distance(origin, point), point },
      else: { max_dist, point }
    end
end

IO.inspect md
IO.inspect Day11.distance origin, to
