# $ crystal hoshimeguri1.cr -- ../data.txt

STAR =
{
  'A' => {'W' => 'I', 'R' => 'H'},
  'I' => {'W' => 'G', 'R' => 'F'},
  'G' => {'W' => 'E', 'R' => 'D'},
  'E' => {'W' => 'C', 'R' => 'B'},
  'C' => {'W' => 'A', 'R' => 'J'},
  'H' => {'W' => 'C', 'R' => 'J'},
  'J' => {'W' => 'E', 'R' => 'B'},
  'B' => {'W' => 'G', 'R' => 'D'},
  'D' => {'W' => 'I', 'R' => 'F'},
  'F' => {'W' => 'A', 'R' => 'H'}
}

def solve(input)
  input.chars[1..-1].reduce([input[0]]) {|a, c| a << STAR[a[-1]][c] }.join
end

def test(input, expected)
  actual = solve(input)
  if actual == expected
    print '.'
  else
    puts <<-EOS

    input:    #{input}
    expected: #{expected}
    actual:   #{actual}
    EOS
  end
end

filename = ARGV.shift
File.each_line(filename) do |line|
  input, expected = line.split
  test input, expected
end
puts
