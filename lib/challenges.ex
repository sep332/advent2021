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
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)
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
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)
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
        |> List.zip() # Convert columns to rows
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(fn digit_list -> # Replace each list with a tuple of {zeros, ones}
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
        |> Enum.map(fn {zeros, ones} -> # Replace each tuple with the most popular digit
            case zeros > ones do
              true -> "0"
              false -> "1"
            end
          end
        )
        |> Day3.gamma_and_epsilon # decimal conversion
        
        gamma * epsilon
      end
    end

    defmodule B do

      def most_popular(data) do
        data
        |> most_popular({0,0})
      end
      def most_popular(["0" | rest], {zeros, ones}) do
        most_popular(rest, {zeros + 1, ones})
      end
      def most_popular(["1" | rest], {zeros, ones}) do
        most_popular(rest, {zeros, ones + 1})
      end
      def most_popular([], {zeros, ones}) when zeros > ones do
        "0"
      end
      def most_popular([], _) do
        "1"
      end

      def most_popular_at_index([_|_] = data, index) do
        data
        |> List.zip()
        |> Enum.map(fn x -> Tuple.to_list(x) end)
        |> Enum.at(index)
        |> most_popular()
      end

      def filter_by_most_popular(data) do
        filter_by_most_popular(data, 0)
      end
      def filter_by_most_popular([last], index) do
        last
      end
      def filter_by_most_popular(data, index) do
        filter_by_most_popular(data, index, most_popular_at_index(data, index))
      end
      def filter_by_most_popular(data, index, filter_value) do
        data
        |> Enum.filter(fn digits -> Enum.at(digits, index) === filter_value end)
        |> filter_by_most_popular(index + 1)
      end
      
      def least_popular(data) do
        data
        |> least_popular({0,0})
      end
      def least_popular(["0" | rest], {zeros, ones}) do
        least_popular(rest, {zeros + 1, ones})
      end
      def least_popular(["1" | rest], {zeros, ones}) do
        least_popular(rest, {zeros, ones + 1})
      end
      def least_popular([], {zeros, ones}) when zeros > ones do
        "1"
      end
      def least_popular([], _) do
        "0"
      end

      def least_popular_at_index([_|_] = data, index) do
        data
        |> List.zip()
        |> Enum.map(fn x -> Tuple.to_list(x) end)
        |> Enum.at(index)
        |> least_popular()
      end

      def filter_by_least_popular(data) do
        filter_by_least_popular(data, 0)
      end
      def filter_by_least_popular([last], index) do
        last
      end
      def filter_by_least_popular(data, index) do
        filter_by_least_popular(data, index, least_popular_at_index(data, index))
      end
      def filter_by_least_popular(data, index, filter_value) do
        data
        |> Enum.filter(fn digits -> Enum.at(digits, index) === filter_value end)
        |> filter_by_least_popular(index + 1)
      end

      def solve(data) do
        generator = 
        data
        |> filter_by_most_popular
        |> Enum.join("")
        |> Advent.Day3.bin_to_dec

        scrubber = 
        data
        |> filter_by_least_popular
        |> Enum.join("")
        |> Advent.Day3.bin_to_dec

        generator * scrubber
      end
    end
  end
end
