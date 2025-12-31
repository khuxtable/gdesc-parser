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
parser grammar GameParser;

options { tokenVocab = GameLexer; }

game
	:	directive+ EOF
	;

// Major language statements

directive
    : includePragma
    | namePragma
    | versionPragma
    | datePragma
    | authorPragma
    | flagDirective
    | stateDirective
    | noiseDirective
    | verbDirective
    | variableDirective
    | arrayDirective
    | textDirective
    | fragmentDirective
    | placeDirective
    | objectDirective
    | actionDirective
    | procDirective
    | initialDirective
    | repeatDirective
    ;

includePragma : INCLUDE STRING_LITERAL (COMMA BOOL_LITERAL)? SEMI ;

namePragma : NAME STRING_LITERAL SEMI ;

versionPragma : VERSION STRING_LITERAL SEMI ;

datePragma : DATE STRING_LITERAL SEMI ;

authorPragma : AUTHOR STRING_LITERAL SEMI ;

flagDirective : FLAGS flagType flagClause (COMMA flagClause)* SEMI ;

stateDirective : STATE stateClause (COMMA stateClause)* SEMI ;

noiseDirective : NOISE IDENTIFIER (IDENTIFIER)* SEMI ;

verbDirective : VERB SUB? IDENTIFIER (IDENTIFIER)* SEMI ;

variableDirective : VARIABLE IDENTIFIER (IDENTIFIER)* SEMI ;

arrayDirective : ARRAY IDENTIFIER LBRACK NUM_LITERAL RBRACK SEMI ;

textDirective : TEXT method? IDENTIFIER textElement+ SEMI ;

fragmentDirective : FRAGMENT method? IDENTIFIER textElement+ SEMI ;

placeDirective : PLACE ADD? IDENTIFIER (IDENTIFIER)* textElement? textElement? optionalBlock ;

objectDirective : OBJECT SUB? IDENTIFIER (IDENTIFIER)* textElement textElement? textElement? optionalBlock ;

actionDirective : ACTION arg1=IDENTIFIER (arg2=IDENTIFIER)? block ;

procDirective : PROC name=IDENTIFIER (IDENTIFIER)* block ;

initialDirective : INITIAL block ;

repeatDirective : REPEAT block ;

flagType
    : VARIABLE
    | OBJECT
    | PLACE
    ;

flagClause : IDENTIFIER (EQUAL IDENTIFIER)* ;

stateClause : IDENTIFIER (EQUAL expression)? ;

method
    : INCREMENT
    | CYCLE
    | RANDOM
    | ASSIGNED
    ;

textElement : TEXT_BLOCK | STRING_LITERAL ;

optionalBlock
    : SEMI
    | block
    ;

// Code block and statements

block
    : LBRACE statement* RBRACE
    ;

statement
    : block
    | emptyStatement
    | localVariableDeclarationStatement
    | expressionStatement
    | breakStatement
    | continueStatement
    | returnStatement
    | ifThenStatement
    | ifThenElseStatement
    | whileStatement
    | repeatStatement
    | basicForStatement
    | enhancedForStatement
    ;

emptyStatement
    : SEMI
    ;

localVariableDeclarationStatement
    : localVariableDeclaration SEMI
    ;

localVariableDeclaration
    : VAR variableDeclarator (COMMA variableDeclarator)*
    ;

variableDeclarator
    : IDENTIFIER (EQUAL expression)?
    ;

expressionStatement
    : statementExpression SEMI
    ;

statementExpression
    : assignment
    | preIncrementOrDecrementExpression
    | postIncrementOrDecrementExpression
    | functionInvocation
    ;

ifThenStatement
    : IF LPAREN expression RPAREN block
    ;

ifThenElseStatement
    : IF LPAREN expression RPAREN block ELSE block
    ;

whileStatement
    : optionalLabel WHILE LPAREN expression RPAREN block
    ;

repeatStatement
    : optionalLabel REPEAT block UNTIL LPAREN expression RPAREN SEMI
    ;

basicForStatement
    : optionalLabel FOR LPAREN forInit? SEMI expression? SEMI forUpdate? RPAREN block
    ;

forInit
    : statementExpressionList
    | localVariableDeclaration
    ;

forUpdate
    : statementExpressionList
    ;

statementExpressionList
    : statementExpression (COMMA statementExpression)*
    ;

enhancedForStatement
    : optionalLabel FOR LPAREN VAR IDENTIFIER COLON expression RPAREN block
    ;

optionalLabel
    : IDENTIFIER COLON
    ;

breakStatement
    : BREAK PROC SEMI
    | BREAK REPEAT SEMI
    | BREAK (IDENTIFIER)? SEMI
    ;

continueStatement
    : CONTINUE PROC SEMI
    | CONTINUE REPEAT SEMI
    | CONTINUE (IDENTIFIER)? SEMI
    ;

returnStatement
    : RETURN expression? SEMI
    ;

/*
 * Expressions
 */

expression
    : conditionalExpression
    | assignment
    ;

assignment
    : lvalue assignmentOperator expression
    ;

lvalue
    : identifierReference
    | arrayAccess
    ;

assignmentOperator
    : EQUAL
    | MUL_ASSIGN
    | DIV_ASSIGN
    | MOD_ASSIGN
    | ADD_ASSIGN
    | SUB_ASSIGN
    | LSHIFT_ASSIGN
    | RSHIFT_ASSIGN
    | URSHIFT_ASSIGN
    | AND_ASSIGN
    | XOR_ASSIGN
    | OR_ASSIGN
    ;

conditionalExpression
    : conditionalOrExpression
    | queryExpression
    ;

queryExpression
    : conditionalOrExpression QUESTION expression COLON conditionalExpression
    ;

conditionalOrExpression
    : conditionalAndExpression
    | conditionalOrExpression OR conditionalAndExpression
    ;

conditionalAndExpression
    : inclusiveOrExpression
    | conditionalAndExpression AND inclusiveOrExpression
    ;

inclusiveOrExpression
    : exclusiveOrExpression
    | inclusiveOrExpression BITOR exclusiveOrExpression
    ;

exclusiveOrExpression
    : andExpression
    | exclusiveOrExpression CARET andExpression
    ;

andExpression
    : equalityExpression
    | andExpression BITAND equalityExpression
    ;

equalityExpression
    : relationalExpression
    | equalityExpression EQUALS relationalExpression
    | equalityExpression NOTEQUALS relationalExpression
    ;

relationalExpression
    : shiftExpression
    | relationalExpression LT shiftExpression
    | relationalExpression GT shiftExpression
    | relationalExpression LE shiftExpression
    | relationalExpression GE shiftExpression
    ;

shiftExpression
    : additiveExpression
    | shiftExpression LSHIFT additiveExpression
    | shiftExpression RSHIFT additiveExpression
    | shiftExpression URSHIFT additiveExpression
    ;

additiveExpression
    : multiplicativeExpression
    | additiveExpression ADD multiplicativeExpression
    | additiveExpression SUB multiplicativeExpression
    ;

multiplicativeExpression
    : unaryExpression
    | multiplicativeExpression MUL unaryExpression
    | multiplicativeExpression DIV unaryExpression
    | multiplicativeExpression MOD unaryExpression
    ;

unaryExpression
    : preIncrementOrDecrementExpression
    | unaryExpressionNotPlusMinus
    | ADD unaryExpression
    | SUB unaryExpression
    ;

preIncrementOrDecrementExpression
    : INC  unaryExpression
    | DEC unaryExpression
    ;

unaryExpressionNotPlusMinus
    : primary
    | postIncrementOrDecrementExpression
    | TILDE unaryExpression
    | BANG unaryExpression
    ;

postIncrementOrDecrementExpression
    : primary INC
    | primary DEC
    ;

primary
    : identifierReference
    | literal
    | parenthesizedExpression
    | arrayAccess
    | functionInvocation
    | refExpression
    | instanceofExpression
    ;

identifierReference
    : IDENTIFIER
    ;

literal
    : NUM_LITERAL
    | BOOL_LITERAL
    | CHAR_LITERAL
    | STRING_LITERAL
    | NULL_LITERAL
    ;

parenthesizedExpression
    : LPAREN expression RPAREN
    ;

arrayAccess
    : IDENTIFIER LBRACK expression RBRACK
    ;

functionInvocation
    : IDENTIFIER LPAREN expressionList? RPAREN
    | STRING_LITERAL LPAREN expressionList? RPAREN
    | internalFunction LPAREN expressionList? RPAREN
    ;

expressionList
    : expression (COMMA expression)*
    ;

internalFunction
    : ANYOF
    | APPEND
    | APPORT
    | ATPLACE
    | CHANCE
    | CLEARFLAG
    | DESCRIBE
    | DROP
    | FLUSH
    | GET
    | GOTO
    | INPUT
    | IN
    | ISAT
    | FLAG
    | HAVE
    | HERE
    | NEAR
    | KEY
    | MOVE
    | NEEDCMD
    | QUERY
    | QUIP
    | RESPOND
    | SAY
    | SETFLAG
    | SMOVE
    | STOP
    | TIE
    | USERTYPED
    | VARIS
    | VOCAB
    ;

refExpression
    : REF IDENTIFIER
    ;

instanceofExpression
    : IDENTIFIER INSTANCEOF refType
    ;

refType
    : OBJECT
    | PLACE
    | VARIABLE
    | TEXT
    | VERB
    ;
