defmodule AdventTest do
  use ExUnit.Case
  doctest Advent


  test "Day 1 A" do
    assert Advent.Day1.test_data |> Advent.Day1.A.solve == Advent.Day1.A.test_answer
  end

  test "Day 1 B" do
    assert Advent.Day1.test_data |> Advent.Day1.B.solve == Advent.Day1.B.test_answer
  end

  test "Day 2 A" do
    assert Advent.Day2.test_data |> Advent.Day2.A.solve == Advent.Day2.A.test_answer
  end

  test "Day 2 B" do
    assert Advent.Day2.test_data |> Advent.Day2.B.solve == Advent.Day2.B.test_answer
  end

  test "Day 3 A" do
    assert Advent.Day3.test_data |> Advent.Day3.A.solve == Advent.Day3.A.test_answer
  end

  test "Day 3 B" do
    assert Advent.Day3.test_data |> Advent.Day3.B.solve == Advent.Day3.B.test_answer
  end

  test "Day 4 A" do
    assert Advent.Day4.test_data |> Advent.Day4.A.solve == Advent.Day4.A.test_answer
  end
end
