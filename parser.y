%{
#include <iostream>
#include <map>

std::map<std::string, float> symbols;

void yyerror(const char* err);
extern int yylex();
%}

%union {
  float value;
  std::string* str;
  int token;
}

/* %define api.value.type { std::string* } */

%token <str> IDENTIFIER
%token <value> NUMBER
%token <token> EQUALS PLUS MINUS TIMES DIVIDEDBY
%token <token> SEMICOLON LPAREN RPAREN

%type <value> expression

%left PLUS MINUS
%left TIMES DIVIDEDBY
/* %right */
/* %nonassoc */
/* %precedence */

%start program

%%

program
  : program statement
  | statement
  ;

statement
  : IDENTIFIER EQUALS expression SEMICOLON
  ;

expression
  : LPAREN expression RPAREN
  | expression PLUS expression
  | expression MINUS expression
  | expression TIMES expression
  | expression DIVIDEDBY expression
  | NUMBER
  | IDENTIFIER
  ;

%%
