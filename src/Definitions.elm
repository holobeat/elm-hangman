module Definitions exposing (..)

{-| Definitions for the game.
-}


{-| This template works properly only on desktop browsers. Mobile browsers
don't seem to handle these characters well (issue with fixed width)
-}
xtemplate =
    "   ╔═════╕ "
        ++ "   ║     │ "
        ++ "   ║     O "
        ++ "   ║    /|\\"
        ++ "   ║    / \\"
        ++ "╔══╩══╗    "
        |> String.toList


{-| Template for the hangman scene ascii graphics. It renders the characters
correctly on all browsers.
-}
template =
    "   _______ "
        ++ "   |     | "
        ++ "   |     O "
        ++ "   |    /|\\"
        ++ "___|___ / \\"
        ++ "|     |    "
        |> String.toList


{-| Sequence in which the parts of the template are displayed
-}
sequence =
    "   2222223 "
        ++ "   1     3 "
        ++ "   1     4 "
        ++ "   1    657"
        ++ "0001000 8 9"
        ++ "0000000    "
        |> String.toList


lastSequence =
    9


stageWidth =
    11


stageHeight =
    6


{-| Game's word list. Replace to your own taste.
-}
wordList =
    List.map
        (\x -> String.toUpper x)
        [ "giraffe"
        , "zebra"
        , "koala"
        , "lizard"
        , "butterfly"
        , "spider"
        , "caterpillar"
        , "beaver"
        , "crocodile"
        , "parrot"
        , "elephant"
        , "monkey"
        , "horse"
        , "porcupine"
        , "alligator"
        , "turtle"
        , "shark"
        , "whale"
        , "dolphin"
        , "tiger"
        ]
