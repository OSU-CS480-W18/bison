%{
#include <iostream>
#include <cstdlib>

#include "parser.hpp"

#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
%}

%option noyywrap
%option yylineno

%%

%{
  /* No code to put at the top of yylex(). */
%}

[ \t\n]*      /* Ignore whitespace. */

[a-z][0-9]?   {
                yylval.str = new std::string(yytext, yyleng);
                return IDENTIFIER;
              }

[0-9]+("."[0-9]+)? {
                     yylval.value = atof(yytext);
                     return NUMBER;
                   }

"="           { return (yylval.token = EQUALS); }
"+"           { return (yylval.token = PLUS); }
"-"           { return (yylval.token = MINUS); }
"*"           { return (yylval.token = TIMES); }
"/"           { return (yylval.token = DIVIDEDBY); }

";"           { return (yylval.token = SEMICOLON); }
"("           { return (yylval.token = LPAREN); }
")"           { return (yylval.token = RPAREN); }

.             {
                std::cerr << "Invalid symbol on line " << yylineno
                  << ": " << yytext << std::endl;
                return yytext[0];
              }

%%
