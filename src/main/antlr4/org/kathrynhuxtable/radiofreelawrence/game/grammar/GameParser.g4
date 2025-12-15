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
parser grammar GameParser;

options { tokenVocab = GameLexer; }

game
	:	directive+ EOF
	;

// Major language statements

directive
    : INCLUDE textLiteral (COMMA boolLiteral)? SEMI         #includePragma
    | NAME textLiteral SEMI                                 #namePragma
    | VERSION textLiteral SEMI                              #versionPragma
    | DATE textLiteral SEMI                                 #datePragma
    | AUTHOR textLiteral SEMI                               #authorPragma
    | FLAGS flagType flagClause (COMMA flagClause)* SEMI    #flagDirective
    | STATE stateClause (COMMA stateClause)* SEMI           #stateDirective
    | NOISE identifier identifier* SEMI                     #noiseDirective
    | VERB SUB? identifier identifier* SEMI                 #verbDirective
    | VARIABLE identifier identifier* SEMI                  #variableDirective
    | ARRAY identifier LBRACK numLiteral RBRACK SEMI        #arrayDirective
    | TEXT method? identifier textElement+ SEMI             #textDirective
    | FRAGMENT method? identifier textElement+ SEMI         #fragmentDirective
    | PLACE ADD? identifier identifier* textElement? textElement? optBlock              #placeDirective
    | OBJECT SUB? identifier identifier* textElement textElement? textElement? optBlock #objectDirective
    | ACTION arg1=identifier arg2=identifier? block         #actionDirective
    | PROC name=identifier identifier* block                #procDirective
    | INITIAL block                                         #initialDirective
    | REPEAT block                                          #repeatDirective
    ;

flagType
    : VARIABLE
    | OBJECT
    | PLACE
    ;

flagClause : identifier (EQUAL identifier)* ;

stateClause : identifier (EQUAL expression)? ;

method
    : INCREMENT
    | CYCLE
    | RANDOM
    | ASSIGNED
    ;

textElement : textBlock | textLiteral ;

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
    : identifier (EQUAL expression)?
    ;

emptyStatement
    : SEMI
    ;

labeledStatement
    : identifier COLON statement
    ;

labeledStatementNoShortIf
    : identifier COLON statementNoShortIf
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
    : FOR LPAREN VAR identifier COLON expression RPAREN statement
    ;

enhancedForStatementNoShortIf
    : FOR LPAREN VAR identifier COLON expression RPAREN statementNoShortIf
    ;

breakStatement
    : BREAK PROC SEMI
    | BREAK REPEAT SEMI
    | BREAK identifier? SEMI
    ;

continueStatement
    : CONTINUE PROC SEMI
    | CONTINUE REPEAT SEMI
    | CONTINUE identifier? SEMI
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
    : identifier
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
    : literal
    | identifier
    | parenthesizedExpression
    | arrayAccess
    | functionInvocation
    | refExpression
    | instanceofExpression
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
    : identifier LBRACK expression RBRACK
    ;

functionInvocation
    : identifier LPAREN expression (COMMA expression)* RPAREN
    | identifier LPAREN RPAREN
    ;

refExpression
    : REF identifier
    ;

instanceofExpression
    : identifier INSTANCEOF refType
    ;

refType
    : OBJECT
    | PLACE
    | VARIABLE
    | TEXT
    | VERB
    ;

// Evaluate lexer elements

numLiteral : NUM_LITERAL ;

boolLiteral : BOOL_LITERAL ;

textLiteral : STRING_LITERAL ;

textBlock : TEXT_BLOCK ;

identifier : IDENTIFIER ;

character : CHAR_LITERAL ;
