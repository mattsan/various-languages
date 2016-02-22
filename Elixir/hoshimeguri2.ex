# $ elixirc hoshimeguri2.ex
# $ elixir -e 'Hoshimeguri2.main' ../data.txt

defmodule Hoshimeguri2 do

  defmodule Solver do
    @star ~c(AHCJEBGDIF)

    def step(p, ?R) when rem(p, 2) == 1 do
      rem(p + 2, 10)
    end

    def step(p, ?W) when rem(p, 2) == 0 do
      rem(p + 8, 10)
    end

    def step(p, _) do
      rem(p + 1, 10)
    end

    def solve(input) do
      input_chars = String.to_char_list(input)
      first_index = Enum.find_index(@star, fn(c) -> c == hd(input_chars) end)
      tl(input_chars)
        |> Enum.reduce([first_index], fn(c, a) -> [step(hd(a), c)|a] end)
        |> Enum.reverse
        |> Enum.map(fn(i) -> Enum.at(@star, i) end)
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
