%{
#include <iostream>
#include <cstdlib>

#include "parser-push.hpp"

YYSTYPE yylval;
YYLTYPE yylloc;

yypstate* pstate = yypstate_new();

#define PUSH_TOKEN(token) do {  \
  int s = yypush_parse(pstate, token, &yylval, &yylloc);  \
  if (s != YYPUSH_MORE) {                                 \
    yypstate_delete(pstate);                              \
    return s;                                             \
  }                                                       \
} while(0)
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
                PUSH_TOKEN(IDENTIFIER);
              }

[0-9]+("."[0-9]+)? {
                     yylval.value = atof(yytext);
                     PUSH_TOKEN(NUMBER);
                   }

"="           { PUSH_TOKEN((yylval.token = EQUALS)); }
"+"           { PUSH_TOKEN((yylval.token = PLUS)); }
"-"           { PUSH_TOKEN((yylval.token = MINUS)); }
"*"           { PUSH_TOKEN((yylval.token = TIMES)); }
"/"           { PUSH_TOKEN((yylval.token = DIVIDEDBY)); }

";"           { PUSH_TOKEN((yylval.token = SEMICOLON)); }
"("           { PUSH_TOKEN((yylval.token = LPAREN)); }
")"           { PUSH_TOKEN((yylval.token = RPAREN)); }

.             {
                std::cerr << "Invalid symbol on line " << yylineno
                  << ": " << yytext << std::endl;
                PUSH_TOKEN(yytext[0]);
              }

<<EOF>>       {
                int s = yypush_parse(pstate, 0, NULL, NULL);
                yypstate_delete(pstate);
                return s;
              }

%%
