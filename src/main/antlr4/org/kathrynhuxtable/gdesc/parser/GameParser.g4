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
    | infoPragma
    | flagDirective
    | stateDirective
    | noiseDirective
    | verbDirective
    | variableDirective
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

infoPragma : INFO gameDescriptor (COMMA gameDescriptor)* SEMI ;

flagDirective : FLAGS flagType flagClause (COMMA flagClause)* SEMI ;

stateDirective : STATE stateClause (COMMA stateClause)* SEMI ;

noiseDirective : NOISE verb (verb)* SEMI ;

verbDirective : VERB verb (verb)* SEMI ;

variableDirective : VARIABLE globalDeclarator (COMMA globalDeclarator)* SEMI ;

textDirective : TEXT method? IDENTIFIER textElement+ SEMI ;

fragmentDirective : FRAGMENT method? IDENTIFIER textElement+ SEMI ;

placeDirective : PLACE IDENTIFIER (EQUAL verb)* textElement? textElement? optionalBlock ;

objectDirective : OBJECT SUB? IDENTIFIER (EQUAL verb)* textElement textElement? textElement? optionalBlock ;

actionDirective : ACTION arg1=verb (arg2=verb)? block ;

procDirective : PROC name=IDENTIFIER (IDENTIFIER)* block ;

initialDirective : INITIAL block ;

repeatDirective : REPEAT block ;

gameDescriptor
    : IDENTIFIER COLON STRING_LITERAL
    ;

flagType
    : VARIABLE
    | OBJECT
    | PLACE
    ;

flagClause : IDENTIFIER (EQUAL IDENTIFIER)* ;

stateClause : IDENTIFIER (EQUAL expression)? ;

verb : STRING_LITERAL ;

globalDeclarator
    : IDENTIFIER
    | IDENTIFIER LBRACK NUM_LITERAL RBRACK
    ;

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
    | ifStatement
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

ifStatement
    : IF LPAREN expression RPAREN block (ELSE IF LPAREN expression RPAREN block)* (ELSE block)?
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
    :
    | IDENTIFIER COLON
    ;

breakStatement
    : BREAK (PROC | REPEAT | IDENTIFIER)? SEMI
    ;

continueStatement
    : CONTINUE (PROC | REPEAT | IDENTIFIER)? SEMI
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
    : relationalExpression
    | andExpression BITAND relationalExpression
    ;

relationalExpression
    : shiftExpression
    | shiftExpression relationalOperator shiftExpression
    ;

relationalOperator
    : EQUALS
    | NOTEQUALS
    | LT
    | GT
    | LE
    | GE
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
    : INC unaryExpression
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
    : IDENTIFIER LPAREN optionalExpressionList RPAREN
    | STRING_LITERAL LPAREN optionalExpressionList RPAREN
    | internalFunction LPAREN optionalExpressionList RPAREN
    ;

optionalExpressionList
    :
    | expression (COMMA expression)*
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
    | ISFLAG
    | HAVE
    | ISHERE
    | ISNEAR
    | ISVERB
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
