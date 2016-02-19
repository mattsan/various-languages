@[Link("star")]
@[Link(ldflags: "-L.")]

lib LibStar
  fun star(p: Char, c: Char): Char
end

def solve(input)
  input.chars[1..-1].reduce([input[0]]) {|a, c| a << LibStar.star(a[-1], c) }.join
end
