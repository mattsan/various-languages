# $ elixirc hoshimeguri2async.ex
# $ elixir -e 'Hoshimegrui2async.main' ../data.txt

defmodule Hoshimegrui2async do

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

    def solve do
      receive do
        {from, input, expected} -> send from, {input, expected, solve(input)}
      end
    end
  end

  defmodule Tester do
    def test(line) do
      [input, expected] = String.split(line, ~r{[ \n]}, trim: true)
      pid = spawn(&Solver.solve/0)
      send pid, {self, input, expected}
    end

    def judge(input, expected, actual) do
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

    def judge(0) do
      :ok
    end

    def judge(n) do
      receive do
        {input, expected, actual} ->
          judge(input, expected, actual)
          judge(n - 1)
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
    Tester.judge(length(lines))
    IO.puts("")
  end
end
