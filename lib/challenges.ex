defmodule Advent do
  def day1a() do
    {answer, _} =
    File.read!("day1.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)

    |> Enum.reduce(
      {-1, 0},
      fn(line, {increases, prev_line}) -> 
        case line > prev_line do
          true -> {increases + 1, line}
          false -> {increases, line}
        end
      end
    )

    answer
  end


  def day1b() do
    {answer, _, _} =
    File.read!("day1.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)

    |> Enum.reduce(
      {-1, {nil, nil}, nil},
      fn
        (line, {increases, {nil, nil}, nil}) -> {increases, {nil, line}, nil}
        (line, {increases, {nil, line1}, nil}) -> {increases, {line1, line}, line1 + line}
        (line, {increases, {line1, line2}, old_sum}) -> 
          case line1 + line2 + line > old_sum do
            true -> {increases + 1, {line2, line}, line1 + line2 + line}
            false -> {increases, {line2, line}, line1 + line2 + line}
          end
      end
    )
        
    answer
  end


  def day2a() do
    {x, y} =
    File.read!("day2.txt")
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") end)

    |> Enum.reduce(
      {0, 0},
      fn
        (["forward", value], {x, y}) -> {x + String.to_integer(value), y}
        (["down", value], {x, y}) -> {x, y + String.to_integer(value)}
        (["up", value], {x, y}) -> {x, y - String.to_integer(value)}
      end
    )

    x * y
  end

  def day2b() do
    {x, y, _} = 
    File.read!("day2.txt")
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") end)

    |> Enum.reduce(
      {0,0,0},
      fn
        (["forward", value], {x, y, aim}) -> {x + String.to_integer(value), y + (String.to_integer(value) * aim), aim}
        (["up", value], {x, y, aim}) -> {x, y, aim - String.to_integer(value)}
        (["down", value], {x, y, aim}) -> {x, y, aim + String.to_integer(value)}
      end
    )

    x * y
  end
end
