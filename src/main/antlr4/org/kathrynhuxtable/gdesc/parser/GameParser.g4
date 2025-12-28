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

placeDirective : PLACE ADD? IDENTIFIER (IDENTIFIER)* textElement? textElement? optBlock ;

objectDirective : OBJECT SUB? IDENTIFIER (IDENTIFIER)* textElement textElement? textElement? optBlock ;

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

optBlock
    : SEMI
    | block
    ;

// Code block and expressions

block
    : LBRACE statement* RBRACE
    ;

statement
    : statementWithoutTrailingSubstatement
    | labeledStatement
    | ifThenStatement
    | ifThenElseStatement
    | whileStatement
    | forStatement
    ;

statementNoShortIf
    : statementWithoutTrailingSubstatement
    | labeledStatementNoShortIf
    | ifThenElseStatementNoShortIf
    | whileStatementNoShortIf
    | forStatementNoShortIf
    ;

statementWithoutTrailingSubstatement
    : block
    | localVariableDeclarationStatement
    | emptyStatement
    | expressionStatement
    | repeatStatement
    | breakStatement
    | continueStatement
    | returnStatement
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

emptyStatement
    : SEMI
    ;

labeledStatement
    : IDENTIFIER COLON statement
    ;

labeledStatementNoShortIf
    : IDENTIFIER COLON statementNoShortIf
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
    : IF LPAREN expression RPAREN statement
    ;

ifThenElseStatement
    : IF LPAREN expression RPAREN statementNoShortIf ELSE statement
    ;

ifThenElseStatementNoShortIf
    : IF LPAREN expression RPAREN statementNoShortIf ELSE statementNoShortIf
    ;

whileStatement
    : WHILE LPAREN expression RPAREN statement
    ;

whileStatementNoShortIf
    : WHILE LPAREN expression RPAREN statementNoShortIf
    ;

repeatStatement
    : REPEAT statement UNTIL LPAREN expression RPAREN SEMI
    ;

forStatement
    : basicForStatement
    | enhancedForStatement
    ;

forStatementNoShortIf
    : basicForStatementNoShortIf
    | enhancedForStatementNoShortIf
    ;

basicForStatement
    : FOR LPAREN forInit? SEMI expression? SEMI forUpdate? RPAREN statement
    ;

basicForStatementNoShortIf
    : FOR LPAREN forInit? SEMI expression? SEMI forUpdate? RPAREN statementNoShortIf
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
    : FOR LPAREN VAR IDENTIFIER COLON expression RPAREN statement
    ;

enhancedForStatementNoShortIf
    : FOR LPAREN VAR IDENTIFIER COLON expression RPAREN statementNoShortIf
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
 * Productions from §15 (Expressions)
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
    : IDENTIFIER LPAREN expression (COMMA expression)* RPAREN
    | IDENTIFIER LPAREN RPAREN
    | internalFunction LPAREN expression (COMMA expression)* RPAREN
    | internalFunction LPAREN RPAREN
    ;

internalFunction
    : ANYOF
    | APPEND
    | APPORT
    | ATPLACE
    | CHANCE
    | CLEARFLAG
    | DESCRIBE_
    | IDROP
    | FLUSHINPUT
    | IGET
    | GOTO
    | INPUT
    | INRANGE
    | ISAT
    | ISFLAG
    | ISHAVE
    | ISHERE
    | ISNEAR
    | KEY
    | MOVE_
    | NEEDCMD
    | GETQUERY
    | QUIP
    | RESPOND
    | SAY_
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
