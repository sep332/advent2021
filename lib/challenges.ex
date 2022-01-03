defmodule Advent do
  defmodule Day1 do
    def real_data do
      File.read!("day1.txt")
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
    end

    def test_data do
      """
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263\
      """
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

      def test_answer do
        7
      end
    end

    defmodule B do

      def solve(data) do
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

      def test_answer do
        5
      end
    end
  end

  defmodule Day2 do

    def real_data do
      File.read!("day2.txt")
      |> String.split("\n")
      |> Enum.map(fn line -> String.split(line, " ") end)
    end

    def test_data do
      """
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2\
      """
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

      def test_answer do
        150
      end
    end

    defmodule B do

      def solve(data) do
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

      def test_answer do
        900
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
      """
      00100
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
      01010\
      """
      |> String.split("\n")
      |> Enum.map(fn line -> String.split(line, "", trim: true) end)
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


      def test_answer() do
        198
      end
    end

    defmodule B do

      def most_popular(values) do
        values
        |> frequencies # could be replaced with Enum.frequencies if you have Elixir >= 1.10
        |> most_popular_value
      end

      def least_popular(values) do
        values
        |> frequencies
        |> least_popular_value
      end

      def frequencies(values, counts \\ %{"0": 0, "1": 0})
      def frequencies(["0" | rest], %{"0": zeros, "1": ones}) do
        frequencies(rest, %{"0": zeros + 1, "1": ones})
      end
      def frequencies(["1" | rest], %{"0": zeros, "1": ones}) do
        frequencies(rest, %{"0": zeros, "1": ones + 1})
      end
      def frequencies([], counts) do
        counts
      end

      def most_popular_value(%{"0": zeros, "1": ones}) when zeros > ones do
        "0"
      end
      def most_popular_value(_), do: "1"

      def least_popular_value(%{"0": zeros, "1": ones}) when zeros <= ones do
        "0"
      end
      def least_popular_value(_), do: "1"

      def most_and_least_popular_at_index({most_data, least_data}, index) do
        {
          most_data
          |> List.zip()
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.at(index)
          |> most_popular,

          least_data
          |> List.zip()
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.at(index)
          |> least_popular
        }
      end

      def filter_by_most_and_least_popular(data, index \\ 0)
      def filter_by_most_and_least_popular({[_last], [_also_last]} = data, _index) do
        data
      end

      # Gotta cheat here for least poular when only one is left so it doesn't get filtered out
      def filter_by_most_and_least_popular({_, [last]} = data, index) do
        {most_value, _least_value} =
        most_and_least_popular_at_index(data, index)

        data
        |> filter_by_most_and_least_popular(index, {most_value, Enum.at(last, index)})
      end
      def filter_by_most_and_least_popular(data, index) do
        filter_by_most_and_least_popular(data, index, most_and_least_popular_at_index(data, index))
      end
      def filter_by_most_and_least_popular({most_data, least_data}, index, {most_value, least_value}) do
        {
          most_data
          |> Enum.filter(fn digits -> Enum.at(digits, index) === most_value end),
          least_data
          |> Enum.filter(fn digits -> Enum.at(digits, index) === least_value end)
        }
        |> filter_by_most_and_least_popular(index + 1)
      end

      def solve(data) do
        {generator_bits, scrubber_bits} =
          {data, data}
          |> filter_by_most_and_least_popular

        ( generator_bits
          |> Enum.join("")
          |> Advent.Day3.bin_to_dec )

        *

        ( scrubber_bits
          |> Enum.join("")
          |> Advent.Day3.bin_to_dec )

      end

      def test_answer do
        230
      end
    end
  end

  defmodule Day4 do

    def test_data do
      """
      7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

      22 13 17 11  0
      8  2 23  4 24
      21  9 14 16  7
      6 10  3 18  5
      1 12 20 15 19

      3 15  0  2 22
      9 18 13 17  5
      19  8  7 25 23
      20 11 10 24  4
      14 21 16 12  6

      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
      2  0 12  3  7\
      """
      |> parse_bingo
    end

    def real_data do
      File.read!("day4.txt")
      |> parse_bingo
    end

    def parse_bingo(bingo_string) do
      [called_string | [board_string]] =
        bingo_string
        |> String.split(~r/\n/, parts: 2)

      called =
        called_string
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      boards =
        board_string
        |> String.split(~r/\n\n/)
        |> Enum.map(fn board -> String.split(board, ~r/ |\n/, trim: true) |> Enum.map(&String.to_integer/1) end)

      {called, boards}
      #|> IO.inspect(label: "input")
    end

    defmodule A do
      def solve({called, boards}) do
        called
        |> check_called(boards)
      end

      def test_answer do
        4512
      end

      def check_called([current | rest], boards) do
        #IO.puts("checking #{current}")
        case check_boards(current, boards) do
          false -> check_called(rest, Enum.map(boards, &filter_board(&1, current)))
          board ->
            board
            |> filter_board(current)
            |> score(current)
        end
      end

      def check_boards(_, []) do
        false
      end
      def check_boards(number, [board | rest]) do
        case win?(number, board) do
          true -> board
          false -> check_boards(number, rest)
        end
      end

      def win?(number, board) do
        win_horizontal?(number, board) || win_vertical?(number, board)
      end

      def win_horizontal?(_, []), do: false
      def win_horizontal?(number, [a, b, c, d, e | rest]) do
        ((number in [a, b, c, d, e]) &&
         (Enum.count([a, b, c, d, e], fn x -> x == -1 end) == 4)) ||
        win_horizontal?(number, rest)
      end

      def win_vertical?(number, board) do
        new_board =
          board
          |> Enum.chunk_every(5)
          |> Enum.zip
          |> Enum.map(&Tuple.to_list/1)
          |> List.flatten

        win_horizontal?(number, new_board)
      end

      def score(board, number) do
        (board
         |> Enum.filter(fn x -> x != -1 end)
         |> Enum.sum)

        *

        number
      end

      def filter_board(board, number) do
        board
        |> Enum.map(
          fn x ->
            case x == number do
              true -> -1
              false -> x
            end
          end
        )
      end

    end
  end
end
