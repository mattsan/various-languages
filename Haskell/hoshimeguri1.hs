--  ビルド:
--    $ ghc --make hoshimeguri1.hs
--
--  実行:
--    $ ./hoshimeguri1 ../data.txt

import System.Environment
import System.IO

star 'A' 'W' = 'I'
star 'A' 'R' = 'H'
star 'I' 'W' = 'G'
star 'I' 'R' = 'F'
star 'G' 'W' = 'E'
star 'G' 'R' = 'D'
star 'E' 'W' = 'C'
star 'E' 'R' = 'B'
star 'C' 'W' = 'A'
star 'C' 'R' = 'J'
star 'H' 'W' = 'C'
star 'H' 'R' = 'J'
star 'J' 'W' = 'E'
star 'J' 'R' = 'B'
star 'B' 'W' = 'G'
star 'B' 'R' = 'D'
star 'D' 'W' = 'I'
star 'D' 'R' = 'F'
star 'F' 'W' = 'A'
star 'F' 'R' = 'H'

solve :: String -> String
solve input =
  reverse $ foldl (\a c -> (star (head a) c):a) [head input] (tail input)

test :: [String] -> IO ()
test [input, expected] =
  if actual == expected
    then putStr "."
    else putStrLn $ concat
      [ "\ninput:    ", input
      , "\nexpected: ", expected
      , "\nacutal:   ", actual
      ]
  where
    actual = solve input

main = getArgs >>= return.head >>= (flip $ openFile) ReadMode >>= hGetContents >>= mapM_ (test.words).lines >> putStrLn ""
