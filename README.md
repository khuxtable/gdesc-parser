# radioactive-free-lawrence

Java re-implementation of the old B adventure game from 1982.

This is very much a work in progress.
Not all features are implemented yet.

## Inspiration

I have taken some concepts from the ACode adventure framework
that Mike Arnautov maintains, but replaced his minor directive
language with my own language, which has a C-like syntax.

In particular, I like having flag values associated with
objects, places, and variables. It enables implementing
a lot more game logic in the game language rather than in
custom code in the game's kernel.

## Architecture

I have created an Antlr4 grammar and I'm using the visitor
pattern to construct a semantic tree from the parsed tree.
I then post-process the semantic tree and construct a "GameData"
object, which holds the game state.

I can interpret the game language code to execute game logic.

I need to pull together a "player" type in which to hold
player information so that the game can be multiplayer.

But if I do that, maybe I shouldn't be developing it in Java.
Maybe it should be Angular, or something.
