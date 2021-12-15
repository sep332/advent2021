defmodule Advent do
  defmodule Day1 do
    def real_data do
      File.read!("day1.txt")
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
    end

    defmodule A do
        
      def solve(data) do
        {answer, _} =
        
        data
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
    end

    defmodule B do
        
      def day1b(data) do
        {answer, _, _} =

        data
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
    end
  end

  defmodule Day2 do

    def real_data do
      File.read!("day2.txt")
      |> String.split("\n")
      |> Enum.map(fn line -> String.split(line, " ") end)
    end

    defmodule A do
        
      def solve(data) do
        {x, y} =
        
        data
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
    end

    defmodule B do
      
      def day2b(data) do
        {x, y, _aim} = 
        
        data
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
  end

  defmodule Day3 do
    def real_data() do
      File.read!("day3.txt")
      |> String.split("\n")
    end

    def test_data() do
"00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"
      |> String.split("\n")
    end

    def test_answer() do
      198
    end

    def gamma_and_epsilon(data) do
      {
        data
        |> Enum.join("")
        |> Advent.Day3.bin_to_dec,
        data
        |> Enum.map(
          fn digit ->
            case digit do
              "0" -> "1"
              "1" -> "0"
            end
          end)
        |> Enum.join("")
        |> Advent.Day3.bin_to_dec
      }
    end

    def bin_to_dec(bin) do
      bin
      |> String.split("", trim: true)
      |> Enum.reduce(
        0,
        fn (digit, dec) -> String.to_integer(digit) + (2 * dec) end
      )
    end

    defmodule A do
      
      def solve(data) do
        {gamma, epsilon} =
        data
        |> Enum.map(fn line -> String.split(line, "", trim: true) end)
        |> List.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn digit_list ->
          Enum.reduce(
            digit_list,
            {0,0},
            fn (digit, {zeros, ones}) -> 
              case digit do
                "0" -> {zeros + 1, ones}
                "1" -> {zeros, ones + 1}
              end
            end
          )
        end)
        |> Enum.map(fn {zeros, ones} -> 
            case zeros > ones do
              true -> "0"
              false -> "1"
            end
          end
        )
        |> Day3.gamma_and_epsilon
        
        gamma * epsilon
      end
    end
  end
end
