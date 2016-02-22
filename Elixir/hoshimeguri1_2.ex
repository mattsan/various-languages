# $ elixirc hoshimeguri1_2.ex
# $ elixir -e 'Hoshimeguri1_2.main' ../data.txt

defmodule Solver do

  @star %{
    ?A => %{?W => ?I, ?R => ?H},
    ?I => %{?W => ?G, ?R => ?F},
    ?G => %{?W => ?E, ?R => ?D},
    ?E => %{?W => ?C, ?R => ?B},
    ?C => %{?W => ?A, ?R => ?J},
    ?H => %{?W => ?C, ?R => ?J},
    ?J => %{?W => ?E, ?R => ?B},
    ?B => %{?W => ?G, ?R => ?D},
    ?D => %{?W => ?I, ?R => ?F},
    ?F => %{?W => ?A, ?R => ?H}
  }

  def solve(input) do
    input_chars = String.to_char_list(input)
    tl(input_chars)
      |> Enum.reduce([hd(input_chars)], fn(c, a) -> [@star[hd(a)][c]|a] end)
      |> Enum.reverse
      |> List.to_string
  end
end

defmodule Tester do
  def test(line) do
    [input, expected] = String.split(line, ~r{[ \n]}, trim: true)
    actual = Solver.solve(input)
    if actual == expected do
      IO.write "."
    else
      IO.write """

      input:    #{input}
      expected: #{expected}
      actual:   #{actual}
      """
    end
  end
end

defmodule Hoshimeguri1_2 do
  defp read_lines(device) do
    line = IO.read(device, :line)
    case line do
      :eof -> []
      _    -> [line|read_lines(device)]
    end
  end

  def main do
    filename = hd(System.argv)
    {:ok, file} = File.open(filename)
    lines = read_lines(file)
    File.close file
    Enum.each lines, &Tester.test(&1)
    IO.puts("")
  end
end
