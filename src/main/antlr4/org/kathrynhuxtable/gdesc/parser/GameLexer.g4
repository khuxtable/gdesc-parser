/*
 [The "BSD licence"]
 Copyright (c) 2013 Terence Parr, Sam Harwell
 Copyright (c) 2017 Ivan Kochurkin (upgrade to Java 8)
 Copyright (c) 2021 Michał Lorek (upgrade to Java 11)
 Copyright (c) 2022 Michał Lorek (upgrade to Java 17)
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
lexer grammar GameLexer;

// Majar directive keywords

INCLUDE : 'include' ;
NAME : 'name' ;
VERSION : 'version' ;
DATE : 'date' ;
AUTHOR : 'author' ;
FLAGS : 'flags' ;
STATE : ('state' | 'constant') ;
TEXT : 'text' ;
FRAGMENT : 'fragment' ;
INCREMENT : 'increment';
CYCLE : 'cycle';
RANDOM : 'random';
ASSIGNED: 'assigned';
PLACE : 'place' ;
OBJECT : 'object' ;
NOISE : 'noise' ;
VERB : 'verb' ;
ACTION : 'action' ;
VARIABLE : 'variable' ;
ARRAY : 'array' ;
PROC : 'proc' ;
INITIAL : 'initial' ;
REPEAT : 'repeat' ;

// Code keywords

BREAK       : 'break';
CASE        : 'case';
CONTINUE    : 'continue';
DEFAULT     : 'default';
ELSE        : 'else';
FOR         : 'for';
IF          : 'if';
INSTANCEOF  : 'instanceof';
REF         : 'ref';
RETURN      : 'return';
SWITCH      : 'switch';
TO          : 'to';
UNTIL       : 'until';
VAR         : 'var';
WHILE       : 'while';

// Internal functions

ANYOF : 'anyof' ;
APPEND : 'append' ;
APPORT : 'apport' ;
ATPLACE : 'atplace' ;
CHANCE : 'chance' ;
CLEARFLAG : 'clearflag' ;
DESCRIBE_ : 'describe_' ;
IDROP : 'idrop' ;
FLUSHINPUT : 'flushinput' ;
IGET : 'iget' ;
GOTO : 'goto' ;
INPUT : 'input' ;
INRANGE : 'inrange' ;
ISAT : 'isat' ;
ISFLAG : 'isflag' ;
ISHAVE : 'ishave' ;
ISHERE : 'ishere' ;
ISNEAR : 'isnear' ;
KEY : 'key' ;
MOVE_ : 'move_' ;
NEEDCMD : 'needcmd' ;
GETQUERY : 'getquery' ;
QUIP : 'quip' ;
RESPOND : 'respond' ;
SAY_ : 'say_' ;
SETFLAG : 'setflag' ;
SMOVE : 'smove' ;
STOP : 'stop' ;
TIE : 'tie' ;
USERTYPED : 'usertyped' ;
VARIS : 'varis' ;
VOCAB : 'vocab' ;


// Literals

NUM_LITERAL : [0-9]+ ;
/*
DECIMAL_LITERAL : ('0' | [1-9] (Digits? | ('_'+ Digits)+));
HEX_LITERAL     : '0' [xX] [0-9a-fA-F] ([0-9a-fA-F_]* [0-9a-fA-F])?;
OCT_LITERAL     : '0' [oO] '_'* [0-7] ([0-7_]* [0-7])?;
BINARY_LITERAL  : '0' [bB] [01] ([01_]* [01])?;
*/

BOOL_LITERAL: 'true' | 'false';

CHAR_LITERAL: '\'' (~['\\\r\n] | EscapeSequence) '\'';

STRING_LITERAL: '"' (~["\\\r\n] | EscapeSequence)* '"';

TEXT_BLOCK: '"""' [ \t]* [\r\n] (. | EscapeSequence)*? '"""';

NULL_LITERAL: 'null';

// Separators

LPAREN : '(';
RPAREN : ')';
LBRACE : '{';
RBRACE : '}';
LBRACK : '[';
RBRACK : ']';
SEMI   : ';';
COMMA  : ',';

// Operators

ADD_ASSIGN     : '+=';
SUB_ASSIGN     : '-=';
MUL_ASSIGN     : '*=';
DIV_ASSIGN     : '/=';
AND_ASSIGN     : '&=';
OR_ASSIGN      : '|=';
XOR_ASSIGN     : '^=';
MOD_ASSIGN     : '%=';
LSHIFT_ASSIGN  : '<<=';
RSHIFT_ASSIGN  : '>>=';
URSHIFT_ASSIGN : '>>>=';

EQUAL     : '=';
LSHIFT    : '<<';
URSHIFT   : '>>>';
RSHIFT    : '>>';
GT        : '>';
LT        : '<';
BANG      : '!';
TILDE     : '~';
QUESTION  : '?';
COLON     : ':';
EQUALS    : '==';
LE        : '<=';
GE        : '>=';
NOTEQUALS : '!=';
AND       : '&&';
OR        : '||';
INC       : '++';
DEC       : '--';
ADD       : '+';
SUB       : '-';
MUL       : '*';
DIV       : '/';
BITAND    : '&';
BITOR     : '|';
CARET     : '^';
MOD       : '%';

// Whitespace and comments

WS           : [ \t\r\n\u000C]+ -> channel(HIDDEN);
COMMENT      : '/*' .*? '*/'    -> channel(HIDDEN);
LINE_COMMENT : '//' ~[\r\n]*    -> channel(HIDDEN);

// Identifiers

IDENTIFIER: Letter LetterOrDigit*;

// Fragment rules

fragment EscapeSequence:
    '\\' 'u005c'? [bstnfr"'\\]
    | '\\' 'u005c'? ([0-3]? [0-7])? [0-7]
    | '\\' 'u'+ HexDigit HexDigit HexDigit HexDigit
;

fragment HexDigits: HexDigit ((HexDigit | '_')* HexDigit)?;

fragment HexDigit: [0-9a-fA-F];

fragment Digits: [0-9]+;

fragment LetterOrDigit: Letter | [0-9] | '.';

fragment Letter:
    [a-zA-Z$_]                        // these are the "java letters" below 0x7F
    | ~[\u0000-\u007F\uD800-\uDBFF]   // covers all characters above 0x7F which are not a surrogate
    | [\uD800-\uDBFF] [\uDC00-\uDFFF] // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
;

/** "catch all" rule for any char not matche in a token rule of your
 *  grammar. Lexers in Intellij must return all tokens good and bad.
 *  There must be a token to cover all characters, which makes sense, for
 *  an IDE. The parser however should not see these bad tokens because
 *  it just confuses the issue. Hence, the hidden channel.
 */
ERRCHAR
	:	.	-> channel(HIDDEN)
	;
