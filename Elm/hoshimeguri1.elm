-- パッケージのインストール
--    $ elm-package install evancz/elm-html
--    $ elm-package install evancz/start-app
--
-- ビルド:
--    $ elm make hoshimeguri1.elm
--
-- 実行:
--    input.html をブラウザで開く

import Graphics.Element exposing (Element, show)
import Html exposing (div, textarea, table, thead, tfoot, tbody, tr, th, td, text)
import Html.Attributes exposing (id, style, cols, rows)
import Html.Events exposing (onClick, on, targetValue)
import List exposing (foldl, head, tail, reverse, map)
import Signal exposing (Address)
import String exposing (toList, fromList, concat, lines, words, join)
import StartApp.Simple as StartApp

head ccs =
  case List.head ccs of
    Just c -> c
    Nothing -> ' '

tail ccs =
  case List.tail ccs of
    Just cs -> cs
    Nothing -> []

star : Char -> Char -> Char
star p c =
  case (p, c) of
    ('A', 'W') -> 'I'
    ('A', 'R') -> 'H'
    ('I', 'W') -> 'G'
    ('I', 'R') -> 'F'
    ('G', 'W') -> 'E'
    ('G', 'R') -> 'D'
    ('E', 'W') -> 'C'
    ('E', 'R') -> 'B'
    ('C', 'W') -> 'A'
    ('C', 'R') -> 'J'
    ('H', 'W') -> 'C'
    ('H', 'R') -> 'J'
    ('J', 'W') -> 'E'
    ('J', 'R') -> 'B'
    ('B', 'W') -> 'G'
    ('B', 'R') -> 'D'
    ('D', 'W') -> 'I'
    ('D', 'R') -> 'F'
    ('F', 'W') -> 'A'
    ('F', 'R') -> 'H'
    _          -> ' '

solve : String -> String
solve input =
  let inputChars = toList input
  in fromList (reverse (foldl (\c a -> (star (head a) c)::a) [head inputChars] (tail inputChars)))

test ss =
  case ss of
    [input, expected] ->
      let actual = solve input
      in
        tr []
          [ td [] [text input]
          , td [] [text expected]
          , td [] [text actual]
          , if actual == expected
              then td [style [("color", "lightgreen")]] [text "Passed"]
              else td [style [("color", "red")]] [text "FAILED"]
          ]
    _ -> text (join "" ss)

view address model =
  div []
    [ textarea
        [ cols 60
        , rows 10
        , on "input" targetValue (Signal.message address)
        ] [model]
    , model
    ]

update action model =
  table []
    [ thead []
        [ tr []
            [ th [] [text "input"]
            , th [] [text "expected"]
            , th [] [text "actual"]
            , th [] [text "status"]
            ]
        ]
    , tbody [style [("font-family", "monospace")]] (map test (map words (lines action)))
    ]

main = StartApp.start { model = (text ""), view = view, update = update }
