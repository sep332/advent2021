defmodule Listy do
  require Integer

  def sum_max_even(list_of_lists) do
    list_of_lists
    |> Enum.map(
      fn list ->
        Stream.unfold( list,
          fn
            [h|t] -> {h,t}
            [] -> {-1,[]}
          end
        )
        |> Enum.take(Enum.max(Enum.map(list_of_lists, &length/1)))
      end
    )
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn items -> Enum.max(Enum.filter([0 | items], (&Integer.is_even/1))) end)
    |> Enum.sum
  end
end
