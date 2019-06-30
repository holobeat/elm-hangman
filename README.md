# elm-hangman
I you are learning a new programming language, it is a good practice to start
with small project. So once you get comfortable with the new language syntax
and basics in core packages, it may be time to create something little more
complex, something beyond 2-button counter app.

Elm-hangman features a list of guess words (theme: animals) and a stage done
with ASCII graphics. Each failed guess adds one part on the hangman stage.
Completed hangman stage results in a loss.

You can test the game directly with `elm reactor`.

To change the guess word list, edit file **Definitions.elm** and update
the *wordList*.
