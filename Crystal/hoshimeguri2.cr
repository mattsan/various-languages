# $ crystal hoshimeguri2.cr -- ../data.txt

STAR = ['A', 'H', 'C', 'J', 'E', 'B', 'G', 'D', 'I', 'F']

def star(i : Nil | Int32) : Char
  case i
  when Int32
    STAR[i]
  else
    ' '
  end
end

def step(p : Nil, c)
end

def step(p : Int32, c)
  case {p % 2, c}
  when {1, 'R'}
    (p + 2) % 10
  when {0, 'W'}
    (p + 8) % 10
  else
    (p + 1) % 10
  end
end

def solve(input : String)
  (input.chars[1..-1] as Array(Char)).reduce([STAR.index(input[0])]) {|indices, c|
    index = indices.last
    index = step(index, c)
    indices.push index
  }.map {|index| star(index) }.join
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
