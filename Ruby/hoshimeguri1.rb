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
  input.chars[1..-1].reduce(input[0]) {|a, c| a << STAR[a[-1]][c] }
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
File.readlines(filename).each do |line|
  test *line.split
end
puts
