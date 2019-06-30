module Main exposing (..)

{-| Hangman game is all about guessing the correct letters to reveal
the whole word. Each wrong guess adds one part to the hangman stage.
10 wrong guesses and the game ends.
-}

import Browser
import Html exposing (Html, div, pre, text, br, button, node)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style, rel, href)
import Html.Events exposing (onClick)
import Random
import Debug exposing (log)
import Definitions
    exposing
        ( template
        , sequence
        , lastSequence
        , stageWidth
        , stageHeight
        , wordList
        )


{-| Messages of the game.
-}
type Msg
    = GuessedChar Char
    | Restart
    | NewRandomNumber Int
    | NextWord


{-| All possible statuses of the game.
-}
type GameStatus
    = Playing
    | Won
    | Lost
    | NotStarted


{-| The one and only source of truth in our game is the Model
-}
type alias Model =
    { stage : List Char
    , step : Int
    , gameStatus : GameStatus
    , guessWords : List String
    , word : String
    , wordProgress : String
    }


{-| Apply mask of characters from 'template' to current stage. The selection
of characters to take from the template is defined in 'sequence' as a single
digit. 'step' parameter tells the function which part to take from
the 'template'.
-}
placePart : Int -> List Char -> List Char -> List Char -> List Char
placePart step template_ sequence_ stage_ =
    let
        match =
            \x y -> String.fromInt x == String.fromChar y
    in
        List.map3
            (\x y z ->
                if match step y then
                    x
                else
                    z
            )
            template_
            sequence_
            stage_


{-| Give the list of space characters that define an empty stage. The length
of the List is defined by width and height of the stage.
-}
emptyStage : Int -> Int -> List Char
emptyStage w h =
    String.repeat (w * h) " " |> String.toList


{-| Insert supplied character into the List after every X number of characters.

    Example:
        insertEvery 3 '.' ['y','y','y','y','y','y','y']

    ...returns:
        ['y','y','y','.','y','y','y','.','y']

-}
insertEvery : Int -> Char -> List Char -> List Char
insertEvery every char oldList =
    insertEvery_ every char oldList [] 1


{-| This function is not called directly. It is called from 'insertEvery',
which simplifies the call.
-}
insertEvery_ : Int -> Char -> List Char -> List Char -> Int -> List Char
insertEvery_ every char oldList newList count =
    case oldList of
        a :: b ->
            if modBy every count == 0 then
                insertEvery_ every char b (newList ++ [ a, char ]) (count + 1)
            else
                insertEvery_ every char b (newList ++ [ a ]) (count + 1)

        [] ->
            newList


{-| Game entry point. We cannot use 'Browser.sandbox' because our game
depends on 'Random' package that utilizes '(Model, Cmd Msg)' as a return
type from the 'update'.
-}
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


{-| Initialize the model with the game status 'NotStarted'
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( { stage = template
      , step = -1
      , gameStatus = NotStarted
      , word = ""
      , guessWords = wordList
      , wordProgress = ""
      }
    , Cmd.none
    )


{-| Respond to all defined game messages and update the Model of our game.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GuessedChar char ->
            let
                nextStep =
                    model.step + 1

                correctGuess =
                    String.contains (String.fromChar char) model.word

                nextWordProgress =
                    revealLetter char model.word model.wordProgress
            in
                if correctGuess then
                    ( { model
                        | wordProgress = nextWordProgress
                        , gameStatus =
                            if model.word == nextWordProgress then
                                Won
                            else
                                Playing
                      }
                    , Cmd.none
                    )
                else
                    ( { model
                        | step = nextStep
                        , stage = placePart nextStep template sequence model.stage
                        , gameStatus =
                            if nextStep == lastSequence then
                                Lost
                            else
                                Playing
                      }
                    , Cmd.none
                    )

        Restart ->
            ( { model
                | gameStatus = Playing
                , step = -1
                , stage = emptyStage stageWidth stageHeight
              }
            , Random.generate NewRandomNumber <|
                Random.int 0 <|
                    (List.length model.guessWords)
                        - 1
            )

        NewRandomNumber number ->
            let
                ( guessWord, updatedGuessWords ) =
                    choose number model.guessWords
            in
                ( { model
                    | word = Maybe.withDefault "" guessWord
                    , guessWords = updatedGuessWords
                    , wordProgress = maskWord '-' <| Maybe.withDefault "" guessWord
                  }
                , Cmd.none
                )

        NextWord ->
            ( { model
                | gameStatus = Playing
                , step = -1
                , stage = emptyStage stageWidth stageHeight
                , guessWords =
                    if model.guessWords == [] then
                        wordList
                    else
                        model.guessWords
              }
            , Random.generate NewRandomNumber <|
                Random.int 0 <|
                    (List.length model.guessWords)
                        - 1
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


{-| Pick a member from the List by index and return the member and a new
List without the member.

    Example:
        choose 1 ['a', 'b', 'c']

    ...returns:
        ('b', ['a', 'c'])

-}
choose : Int -> List a -> ( Maybe a, List a )
choose index items =
    let
        item =
            List.head <| List.drop (index) items

        start =
            List.take index items

        end =
            List.drop (index + 1) items
    in
        ( item, start ++ end )


{-| Reveal the character(s) within the masked word.

    Example:
        revealLetter 'o' "automobile" "a********e"

    ...returns:
        "a**o*o***e"

-}
revealLetter : Char -> String -> String -> String
revealLetter char word maskedWord =
    List.map2
        (\x y ->
            if x == char then
                x
            else
                y
        )
        (String.toList word)
        (String.toList maskedWord)
        |> String.fromList


{-| Take a word and mask it with the provided character, revealing only
first and last letter.

    Example:
        maskWord '*' "telephone"

    ...returns:
        "t*******e"

-}
maskWord : Char -> String -> String
maskWord maskChar word =
    let
        mask =
            String.repeat ((String.length word) - 2) <| String.fromChar maskChar
    in
        String.left 1 word ++ mask ++ String.right 1 word


{-| All the visual presentation is done here. All the major styling here is done
via other functions like 'styleGame' and 'styleStage', so we don't pollute
the main view function with bunch of element styles.
-}
view : Model -> Html Msg
view model =
    div
        ([] ++ styleGame)
        [ div [ style "font-size" "2em" ] [ text "HANGMAN" ]
        , br [] []
        , pre
            ([] ++ styleStage)
            [ text <|
                String.fromList <|
                    insertEvery 11 '\n' <|
                        model.stage
            ]
        , br [] []
        , case model.gameStatus of
            Playing ->
                viewGame model

            Won ->
                viewResult "CORRECT!"

            Lost ->
                viewResult <| "SORRY! The correct word is " ++ model.word

            NotStarted ->
                viewStart
        ]


viewResult : String -> Html Msg
viewResult message =
    div []
        [ text <| message
        , br [] []
        , br [] []
        , button [ onClick NextWord ] [ text "NEXT WORD" ]
        ]


viewStart : Html Msg
viewStart =
    div []
        [ text "WORD THEME: ANIMALS"
        , br [] []
        , br [] []
        , button [ onClick Restart ] [ text "START" ]
        ]


viewGame : Model -> Html Msg
viewGame model =
    div []
        [ div [ style "font-size" "1.5em" ] [ text model.wordProgress ]
        , br [] []
        , viewKeyboard model
        ]


viewKeyboard : Model -> Html Msg
viewKeyboard model =
    let
        alphabet =
            String.toList "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    in
        div [] <|
            List.map
                (\x ->
                    button ([ onClick (GuessedChar x) ] ++ styleKeyboadButton)
                        [ text <| String.fromChar x ]
                )
                alphabet


styleKeyboadButton : List (Html.Attribute Msg)
styleKeyboadButton =
    [ style "border" "1px solid gray"
    , style "background-color" "#eeeeee"
    , style "border-radius" "5px"
    , style "margin" "2px"
    , style "font-family" "inherit"
    ]


styleGame : List (Html.Attribute Msg)
styleGame =
    [ style "border" "1px solid black"
    , style "padding" "20px"
    , style "width" "200px"
    , style "margin" "0 auto"
    , style "text-align" "center"
    , style "font-family" "monospace"
    , style "background-color" "#dddddd"
    , style "zoom" "200%"
    ]


styleStage : List (Html.Attribute Msg)
styleStage =
    [ style "border-bottom" "1px solid black"
    , style "background-color" "#eeeeee"
    , style "margin" "10px"
    , style "width" "150px"
    , style "margin" "0 auto"
    , style "font-family" "monospace, monospace"
    , style "font-size" "1em"
    ]
