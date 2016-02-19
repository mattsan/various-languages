require "solver1"

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
