# gdesc-parser - Game Description Parser

An Antlr4 parser for a text-based Adventure grammar.
This is a Java re-implementation of the old B Adventure
game from 1982.

This is shared by the game engine itself,
and by an IntelliJ plugin supporting language editing.

## Inspiration

I have taken some concepts from the ACode adventure framework
that Mike Arnautov maintains, but replaced his minor directive
language with my own language, which has a C-like syntax.

In particular, I like having flag values associated with
objects, places, and variables. It enables implementing
a lot more game logic in the game language rather than in
custom code in the game's kernel.

## Architecture

This project creates a Visitor interface that the game
can implement to construct its semantic tree.

The plugin does not make use of this interface,
because the IntelliJ AST scheme doesn't use Antlr
typically.
