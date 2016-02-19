# $ crystal hoshimeguri1_1.cr -- ../data.txt

require "tester1"

filename = ARGV.shift
File.each_line(filename) do |line|
  input, expected = line.split
  test input, expected
end
puts
