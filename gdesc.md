# Game Description Language

The files consist of a sequence of directive statements.

## GDesc Directives

Directives are high level descriptive elements,
consisting of game information, file include statements,
and global definitions, such as variables, general purpose
executable game code, text statements
that can be displayed, objects that can be encountered,
picked up, etc., and places you can visit.

### The **include** Directive

The include directive specifies a file to include. an optional true/false 
value specifies whether the file is optional. If not specified, or false,
an error will be generated if the requested file does not exist or is
not readable, otherwise if not available the file will be ignored.

Syntax:
```gdesc
include "filename" [, true];
```

### The **info** Directive

The info directive provides game information to be displayed upon startup.
Typical keys are "name", "version", "author", and "date", e.g.

```gdesc
info
    name: "Demo Game",
    version: "1.0",
    author: "Bogus Joe";
```

Syntax:
```gdesc
info keyname: "value" [, keyname: "value"]*;
```

### The **flag** Directive

The flag directive defines flags associated with variables, objects, or places.
If, say, this is an object flag, each object will have an instance of the flag
associated with it that can be set, cleared, and tested.

For game readability, synonyms can be declared using an equals sign.

Syntax:
```gdesc
flags [variable|object|place] (identifier (=identifier)*) (,identifier (=identifier)*)*;
```

### The ***state*** Directive

The state directive defines variables and assigns default values or the values supplied.
These variables are intended to hold game state.

Syntax:
```gdesc
state identifier (= expression)? (, identifier (= expression)?)*;
```

### The **noise** Directive

The noise directive defines vocabulary words that will be ignored,
such as "and", "the", etc.

Syntax:
```gdesc
noise "word" "word"*;
```

### The **verb** Directive

The verb directive defines words that can be used by the player on command lines.
All words specified on a directive are synonyms with each other.

Any word the player is expected to use MUST be specified in a verb or a noise directive.

Within the code blocks, the first word must be used.

Syntax:
```gdesc
verb "word" "word"*;
```

### The **variable** Directive

The variable directive defines variables and arrays that can be used to store
game information. I'm not sure there is value in having these separate from the states.

Syntax:
```gdesc
variable globalDeclarator (, globalDeclarator)* ;
```
globalDeclarator:
```gdesc
identifier
identifier [ number ]
```

### The **text** Directive

The text directive defines text elements and text blocks to use for messages to the player.
There are complex rules for substituting values into the text.

If multiple text element values are supplied, the optional "method" (increment, cycle, etc.)
specify how to switch between them, so that a variety of responses can be delivered.

Syntax:
```gdesc
text [increment|cycle|random|assigned]? identifier textElement+ ;
```

Text elements are either single-line text strings delimited by double quote characters, e.g.
```gdesc
"This is a text string"
```
or text blocks, delimited by three double quote characters.
The introducing triple double quote *must* be followed by a new line.
The shortest number of initial spaces in the block will be deleted from each line.
```gdesc
// This is a comment to show leading spaces.
    """
    This is a multi-line
        text block.
    The first four characters of each line will be removed."""
```
yielding:
```text
This is a multi-line
    text block.
The first four characters of each line will be removed.
```

### The **fragment** Directive

The fragment directive is identical with the text directive,
except that it is not terminated by a new line.
It is intended to be inserted into other text elements.

Syntax:
```gdesc
fragment [increment|cycle|random|assigned] identifier textElement+ ;
```

### The **place** Directive

The place directive defines a location in the game that a player might travel to.

The identifier is also added as a verb, and is the name that must be used in the code blocks to identify the place.

The other words are synonyms that can be used as player vocabulary.

The first text element is the "short name", that will appear after the first time the player has been here.

The second text element is the long description, which will be displayed the first time the player visits,
and when the player enters the "look" command.

The directive must end with a code block or a semicolon (not both).

Syntax:
```gdesc
place identifier (= "word")* textElement? textElement? [block|;]
```

### The **object** Directive

The object directive defines an object in the game that a player might encounter, pick up, put down, etc.

The identifier is added as a verb unless preceded by a minus sign,
and is the name that must be used in the code blocks to identify the object.

The other words are synonyms that can be used as player vocabulary.

The first text element is the "inventory description", used when taking inventory.

The second text element is the "short description", that will appear when visiting the object's location,
or when using the "look" command.

The third text element is the long description, which will be displayed the first time the player visits,
and when the player enters the "describe" command followed by the object name.

The directive must end with a code block or a semicolon (not both).

Syntax:
```gdesc
object [-] identifier (= "word")* textElement textElement? textElement? [block|;]
```

### The **action** Directive

The action directive specifies a code block to execute when the words are matched.

The first word is the verb, and the second is an optional noun or other second word.

Syntax:
```gdesc
action "word" ["word"] block
```

### The **proc** Directive

The proc directive specifies a code block "function" that can be called with parameters.

The first identifier is the name, and the optional additional identifiers are parameter names.

Syntax:
```gdesc
proc identifier identifier* block
```

### The **initial** Directive

The initial directive specifies code blocks to be executed on game startup.
Multiple initial directives can be specified and they will be executed in the order they are declared.

Syntax:
```gdesc
initial block
```

### The **repeat** Directive

The repeat directive is the main player game loop.
Multiple repeat directives can be specified, and they will be executed in the order they are declared
for each game loop iteration.

Syntax:
```gdesc
repeat block
```

## Code Blocks and Statements

Much of the game depends on executing code blocks.
These are a Java-like language with simple variables that the game engine can execute.

### The **code block**

A code block is a sequence of zero or more statements surrounded by curly braces.
It is the top-level element of the executable portions of the language,
and is used to group statements in if/else or loop statements.
It also controls local variable scoping.
A variable declared in a code block is accessible to statements in that block,
and any nested blocks, but not outer blocks.

Syntax:
```gdesc
{ statement* }
```

### The **empty** Statement

Sometimes you need a statement, but it doesn't need to do anything.
A simple semicolon suffices.

Syntax:
```gdesc
;
```

### The **local variable declaration** Statement

Usable anywhere within a code block, variable declarations define local varables.
If the optional expression is supplied, an initial value is computed and assigned
to the variable.
Multiple variables can be declared in one statement,
or you can specify multiple statements.

Any variables used in the expression must already be declared and have values.

Syntax:
```gdesc
var identifier [= expression] (, identifier [= expression])*;
```

### The **expression** Statement

The expression statement is the workhorse of the code block.

There are some restrictions on the type of expression allowed.
It can be an assignment expression, a pre/post increment/decrement expression,
or a function call.

This means that expressions with a simple operator, such as addition or a comparison,
are not permitted unless the expression is used in an assignment expression.

Syntax:
```gdesc
expression ;
```

### The **if** Statement

The if statement is used to make choices.
It consists of an initial "if" followed by an expression in parentheses followed by a code block,
then a sequence of zero or more "else if" sequences, and finally an optional "else".

Note that simple statements are not allowed; you must use a code block after each expression.

Each expression in turn will be evaluated and if true, the following block will be executed.
Once a block is executed, the remaining expressions and blocks are skipped.
If no expression is true and a final "else" is present, its block will be executed.

Syntax:
```gdesc
if ( expression ) block (else if ( expression ) block)* [else block]
```

### The **while** Statement

The while statement provides simple looping with a "pre-test".

The expression is evaluated, and if true, the block is executed, otherwise move to the next statement.
Repeat until the expression evaluates to false, or a loop control statement (break, continue, return)
is executed.

The optional identifier followed by a colon labels the loop so that loop control statements
can control outer loops. This is not common, but is sometimes needed.

Syntax:
```gdesc
[identifier:] while ( expression ) block
```

### The **repeat** Statement

The repeat statement provides simple looping with a "post-test".

The block is executed, then the expression is evaluated, and if false, the block is executed again,
otherwise move to the next statement.
Repeat until the expression evaluates to true, or a loop control statement (break, continue, return)
is executed.

The optional identifier followed by a colon labels the loop so that loop control statements
can control outer loops. This is not common, but is sometimes needed.

Syntax:
```gdesc
[identifier:] repeat block until ( expression );
```

### The **basic for** Statement

The basic for statement provides simple looping with initialization, test, and update clauses.
This is the most generic loop construct.

The "forInit" clauses are comma delimited and are a sequence of
either expression statements or local variable declarations.

The "forUpdate" clauses are a comma delimited sequence of expression statements.

The initialization clauses are executed, the expression is tested and if true, the block is executed,
or execution moves to the next statement.
After executing the block, the update clauses are executed and the expression is tested again.
Repeat until the expression evaluates to false, or a loop control statement (break, continue, return)
is executed. In the case of break or return, the update clauses are not executed.

The optional identifier followed by a colon labels the loop so that loop control statements
can control outer loops. This is not common, but is sometimes needed.

Syntax:
```gdesc
[identifier:] for ( forInit?; [expression]; [forUpdate] ) block
```

### The **enhanced for** Statement

The enhanced for statement specifically iterates over an expression's values.
Since this is a very simple language, the expression will typically infer the 
values from the type of expression. If the expression is a place, for instance,
the identifier will iterate over all objects in the place.

The optional identifier followed by a colon labels the loop so that loop control statements
can control outer loops. This is not common, but is sometimes needed.

Syntax:
```gdesc
[identifier:] for (var identifier : expression) block
```

### The **break** Statement

The break statement is a loop control statement, though it can be used to control execution
in any top-level code block.

A simple break statement stops execution of the current code block within a loop,
moving to the next statement after the loop.

If an identifier is specified, the identifier must correspond to a label identifier for
an enclosing loop, and that loop is the one whose execution is stopped.

The "break proc" usage stops execution of the current outer code block for a directive.
If there are multiple code blocks with the same name, e.g. actions with the same verb,
initial or repeat directives, etc., the next block in sequence is executed.

The "break repeat" usage is like "break proc", but skips the remaining code blocks with the same name.

Syntax:
```gdesc
break [proc | repeat | identifier];
```

### The **continue** Statement

The continue statement is a loop control statement, though it can be used to control execution
in any top-level code block.

A simple continue statement stops execution of the current code block within a loop,
moving to the update clauses for a basic for loop, or the expression test for while or repeat loops,
or the next value for the enhanced for loop.

If an identifier is specified, the identifier must correspond to a label identifier for
an enclosing loop, and that loop is the one whose execution is stopped.

The "continue proc" usage stops execution of the current outer code block for a directive.
If there are multiple code blocks with the same name, e.g. actions with the same verb,
initial or repeat directives, etc., the next block in sequence is executed.

The "continue repeat" usage is like "continue proc", but skips the remaining code blocks with the same name.

Syntax:
```gdesc
continue [proc | repeat | identifier];
```

### The **return** Statement

The return statement stops execution of an outer code block for a directive,
optionally returning a value. If no expression is supplied, zero will be returned.

The return value can be used when an action or proc is executed via a function call.

Syntax:
```gdesc
return [expression];
```

## Expressions

Expressions are modeled on Java expressions, but since the data is simpler,
the expressions are simpler.

### Assignment Expressions

Assignments have either an identifier, or an array access, followed by an operator, followed by an expression.

If not a simple equal, the operation will be performed on the left-hand side and right-hand side,
then the result will be assigned to the left-hand side.

Valid operators are:

| operator | value                            |
|----------|----------------------------------|
| =        | assign                           |
| *=       | multiply then assign             |
| /=       | divide then assign               |
| %=       | mod then assign                  |
| +=       | add then assign                  |
| -=       | subtract then assign             |
| <<=      | left shift then assign           |
| >>=      | right shift then assign          |
| >>>=     | unsigned right shift then assign |
| &=       | bitwise and then assign          |
| ^=       | bitwise xor then assign          |
| \|=      | bitwise or then assign           |

```gdesc
identifier operator expression
identifier [ expression ] operator expression
```
### Query/Ternary Expressions

The query, or ternary, operator is a way to include a simple test in an expression.
Its use should only be when the test is simple, for instance,
when testing an invalid value and providing an alternative, e.g. the following,
which returns 0 if myVar is negative, otherwise returns myVar.

```gdesc
myVar < 0 ? 0 : myVar
```

Syntax:
```gdesc
conditionalOrExpression ? expression : conditionalExpression
```

### Conditional Expressions

Conditional expressions are the same as in any Java-like language.

The "logical" operators terminate the tests once the final value is known,
whereas the bitwise operators perform bitwise tests on the values.

| operator | value       |
|----------|-------------|
| \|\|     | logical or  |
| &&       | logical and |
| \|       | bitwise or  |
| ^        | bitwise xor |
| &        | bitwise and |

### Relational Expressions

Relational expressions are strictly binary. You cannot chain them.

| operator | value                 |
|----------|-----------------------|
| ==       | equal                 |
| !=       | not equal             |
| \<       | less than             |
| \>       | greater than          |
| \<=      | less than or equal    |
| \>=      | greater than or equal |

### Other Binary Expressions

These are listed in precedence group order.

| operator    | value                   |
|-------------|-------------------------|
| \<\<        | left shift              |
| \>\>        | right shift             |
| \>\>\>      | unsigned right shift    |

| operator | value    |
|----------|----------|
| +        | add      |
| -        | subtract |

| operator | value    |
|----------|----------|
| *        | multiply |
| /        | divide   |
| %        | modulus  |

### Unary Expressions

These can all be used in front of the operand.

The increment and decrement can also be used after the operand,
in which case the operation is performed *after* returning the result.

| operator | value              |
|----------|--------------------|
| +        | positive           |
| -        | negative           |
| ~        | bitwise complement |
| !        | not                |
| ++       | increment          |
| --       | decrement          |

### Primary Expressions

These are the deepest nested elements.

They consist of

 - identifier
 - identifier [ expression ]
 - function ( [expression (, expression)*] )
 - ref expression
 - expression instanceof [OBJECT | PLACE | VARIABLE | TEXT | VERB]
 - ( expression )
 - literal

A literal is either an integer, a single-quoted character, the boolean values `true` or `false`,
a double-quoted text string, or the value `null`.

A function is either a built-in function, a proc identifier,
or a string literal corresponding to an action verb.

### Internal Functions

Internal functions are provided by the game engine to perform actions that are either very common,
critical enough to not allow overriding, or that require access to internal data.

#### The **anyof** function

#### The **append** function
#### The **apport** function
#### The **at** function
#### The **chance** function
#### The **clearflag** function
#### The **describe** function
#### The **drop** function
#### The **flush** function
#### The **get** function
#### The **goto** function
#### The **input** function
#### The **in** function
#### The **isat** function
#### The **isflag** function
#### The **have** function
#### The **ishere** function
#### The **isnear** function
#### The **key** function
#### The **move** function
#### The **needcmd** function
#### The **query** function
#### The **quip** function
#### The **respond** function
#### The **say** function
#### The **setflag** function
#### The **smove** function
#### The **stop** function
#### The **tie** function
#### The **usertyped** function
#### The **varis** function
#### The **vocab** function
