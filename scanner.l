%{
#include <iostream>
#include <vector>
#include <set>

struct _word {
  std::string lexeme;
  std::string category;
};

std::vector<struct _word> _words;
std::set<std::string> _ids;
bool _error = false;

void _save_word(const std::string& lexeme, const std::string& category) {
  struct _word _word = {
    .lexeme = lexeme,
    .category = category
  };
  _words.push_back(_word);
}

%}

%option noyywrap
%option yylineno

%%

%{
  /* No code to put at the top of yylex(). */
%}

[ \t\n]*      /* Ignore whitespace. */

[a-z][0-9]?   {
                _save_word(yytext, "IDENTIFIER");
                _ids.insert(yytext);
              }

[0-9]+("."[0-9]+)? { _save_word(yytext, "NUMBER"); }

"="           { _save_word(yytext, "EQUALS"); }
"+"           { _save_word(yytext, "PLUS"); }
"-"           { _save_word(yytext, "MINUS"); }
"*"           { _save_word(yytext, "TIMES"); }
"/"           { _save_word(yytext, "DIVIDEDBY"); }

";"           { _save_word(yytext, "SEMICOLON"); }
"("           { _save_word(yytext, "LPAREN"); }
")"           { _save_word(yytext, "RPAREN"); }

.             {
                std::cerr << "Invalid symbol on line " << yylineno
                  << ": " << yytext << std::endl;
                _error = true;
              }

<<EOF>>       {
                if (_error) {
                  return 1;
                }
                return 0;
              }


%%

int main() {
  if (!yylex()) {
    std::vector<struct _word>::iterator wit;
    for (wit = _words.begin(); wit != _words.end(); ++wit) {
      std::cout << wit->lexeme << "\t" << wit->category << std::endl;
    }

    std::cout << std::endl << "Identifiers:" << std::endl;
    std::set<std::string>::iterator iit;
    for (iit = _ids.begin(); iit != _ids.end(); ++iit) {
      std::cout << *iit << std::endl;
    }
  }
}
