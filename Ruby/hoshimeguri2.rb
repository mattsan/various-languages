STAR = %w(A H C J E B G D I F)
STEP = {[0, 1] => 1, [1, 0] => 1, [1, 1] => 2, [0, 0] => -2}
COLOR = {'W' => 0, 'R' => 1}

def solve(input)
  input.chars[1..-1].reduce([STAR.index(input[0])]) {|indices, c|
    index = indices[-1]
    index = (index + STEP[[index % 2, COLOR[c]]]) % 10
    indices << index
  }.map {|index| STAR[index] }.join
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
