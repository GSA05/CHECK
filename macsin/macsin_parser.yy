%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0"
%defines
%define parser_class_name {macsin_parser}
%define api.namespace {macsin}
%define api.token.constructor
%define api.value.type variant
%define parse.assert
%code requires
{
#include <string>
class macsin_controller;
}
// The parsing context.
%param { macsin_controller& controller }
%locations
%initial-action
{
    // Initialize the initial location.
    @$.begin.filename = @$.end.filename = &controller.file;
};
%define parse.trace
%define parse.error verbose
%code
{
#include "macsin_controller.h"
}
%define api.token.prefix {TOK_}
%token
    END 0   "end of line"
    ASSIGN  ":="
    MINUS   "-"
    PLUS    "+"
    STAR    "*"
    SLASH   "/"
    LPAREN  "("
    RPAREN  ")"
;
%token <std::string> IDENTIFIER "identifier"
%token <int> NUMBER "number"
%type  <int> exp
%printer { yyoutput << $$; } <*>;
%%
%start unit;
unit: assignments exp   { controller.result = $2; };

assignments:
    /* empty */             {}
|   assignments assignment  {};

assignment:
    "identifier" ":=" exp { controller.variables[$1] = $3; };

%left "+" "-";
%left "*" "/";
exp:
    exp "+" exp  { $$ = $1 + $3; }
|   exp "-" exp  { $$ = $1 - $3; }
|   exp "*" exp  { $$ = $1 * $3; }
|   exp "/" exp  { $$ = $1 / $3; }
|   "(" exp ")"  { std::swap ($$, $2); }
|   "identifier" { $$ = controller.variables[$1]; }
|   "number"     { std::swap ($$, $1); };
%%
void
macsin::macsin_parser::error (const location_type& l,
                          const std::string& m)
{
    controller.error (l, m);
}
