--  ビルド:
--    $ ghc --make hoshimeguri2.hs
--
--  実行:
--    $ ./hoshimeguri2 ../data.txt

import Data.List
import System.Environment
import System.IO

star = "AHCJEBGDIF"
step i c =
  case (i `mod` 2, c) of
    (1, 'R') -> 2
    (0, 'W') -> -2
    (_, _  ) -> 1

solve :: String -> String
solve input =
  map (\i -> star !! i) $ reverse $ foldl (\a c -> (((head a) + (step (head a) c)) `mod` 10):a) [first] (tail input)
  where
    Just first = elemIndex (head input) star

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

main = getArgs >>= return.head >>= (flip openFile) ReadMode >>= hGetContents >>= mapM_ (test.words).lines >> putStrLn ""
