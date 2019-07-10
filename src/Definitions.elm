module Definitions exposing (..)

{-| Definitions for the game.
-}


{-| This template works properly only on desktop browsers. Mobile browsers
don't seem to handle these characters well (issue with fixed width)
-}
xtemplate : List Char
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
template : List Char
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
sequence : List Char
sequence =
    "   2222223 "
        ++ "   1     3 "
        ++ "   1     4 "
        ++ "   1    657"
        ++ "0001000 8 9"
        ++ "0000000    "
        |> String.toList


lastSequence : Int
lastSequence =
    9


stageWidth : Int
stageWidth =
    11


stageHeight : Int
stageHeight =
    6


{-| All allowed guess characters from the keyboard input.
Everything else will be filtered out.
-}
alphabet : String
alphabet =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"


{-| Game's word list. Replace to your own taste.
-}
wordList : List String
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
