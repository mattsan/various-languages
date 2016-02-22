# star.c, libs/solver1.cr, libs/tester1.cr を利用する
#
# ライブラリのビルド:
#   $ gcc -dynamiclib -o libstar.dylib star.c
#
# 実行:
#   $ crystal hoshimeguri1_1.cr -- ../data.txt
#
# ビルドしてからの実行:
#   $ crystal build hoshimeguri1_1.cr
#   $ ./hoshimeguri1_1 ../data.txt

require "tester1"

filename = ARGV.shift
File.each_line(filename) do |line|
  input, expected = line.split
  test input, expected
end
puts
