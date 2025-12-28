/*
 * Copyright © 2017, 2025, 2026 Kathryn A Huxtable
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
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
