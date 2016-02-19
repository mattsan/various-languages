# $ elixir hoshimeguri1.ex ../data.txt

defmodule Solver do

  defp star(?A, ?W) do ?I end
  defp star(?A, ?R) do ?H end
  defp star(?I, ?W) do ?G end
  defp star(?I, ?R) do ?F end
  defp star(?G, ?W) do ?E end
  defp star(?G, ?R) do ?D end
  defp star(?E, ?W) do ?C end
  defp star(?E, ?R) do ?B end
  defp star(?C, ?W) do ?A end
  defp star(?C, ?R) do ?J end
  defp star(?H, ?W) do ?C end
  defp star(?H, ?R) do ?J end
  defp star(?J, ?W) do ?E end
  defp star(?J, ?R) do ?B end
  defp star(?B, ?W) do ?G end
  defp star(?B, ?R) do ?D end
  defp star(?D, ?W) do ?I end
  defp star(?D, ?R) do ?F end
  defp star(?F, ?W) do ?A end
  defp star(?F, ?R) do ?H end

  def solve(input) do
    input_chars = String.to_char_list(input)
    List.to_string(Enum.reverse(Enum.reduce(tl(input_chars), [hd(input_chars)], fn(c, a) -> [star(hd(a), c)|a] end)))
  end
end

defmodule Hoshimeguri do
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

  defp read_lines(device) do
    line = IO.read(device, :line)
    case line do
      :eof -> []
      _    -> [line|read_lines(device)]
    end
  end

  def main(filename) do
    {:ok, file} = File.open(filename)
    lines = read_lines(file)
    File.close file
    Enum.each lines, &test(&1)
    IO.puts("")
  end
end

Hoshimeguri.main(hd(System.argv))
