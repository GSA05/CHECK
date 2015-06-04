%{ /* -*- C++ -*- */
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <string>
#include "macsin_controller.h"
#include "macsin_parser.tab.hh"

// Work around an incompatibility in flex (at least versions
// 2.5.31 through 2.5.33): it generates code that does
// not conform to C89. See Debian bug 333231
// <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=333231>.
#undef yywrap
#define yywrap() 1

// The location of the current token.
static macsin::location loc;
%}
%option noyywrap nounput batch debug noinput
%option outfile="lex.macsin.cc"
id    [a-zA-Z][a-zA-Z_0-9]*
int   [0-9]+
blank [ \t]
%{
    // Code run each time a pattern is matched.
    #define YY_USER_ACTION loc.columns (yyleng);
%}
%%
%{
    // Code run each time yylex is called.
    loc.step ();
%}
{blank}+    loc.step ();
[\n]+       loc.lines (yyleng); loc.step ();
"-"     return macsin::macsin_parser::make_MINUS(loc);
"+"     return macsin::macsin_parser::make_PLUS(loc);
"*"     return macsin::macsin_parser::make_STAR(loc);
"/"     return macsin::macsin_parser::make_SLASH(loc);
"("     return macsin::macsin_parser::make_LPAREN(loc);
")"     return macsin::macsin_parser::make_RPAREN(loc);
":="    return macsin::macsin_parser::make_ASSIGN(loc);
{int}   {
    errno = 0;
    long n = strtol (yytext, NULL, 10);
    if (! (INT_MIN <= n && n <= INT_MAX && errno != ERANGE))
        controller.error (loc, "integer is out of range");
    return macsin::macsin_parser::make_NUMBER(n, loc);
}
{id}    return macsin::macsin_parser::make_IDENTIFIER(yytext, loc);
.       controller.error (loc, "invalid character");
<<EOF>> return macsin::macsin_parser::make_END(loc);
%%
void
macsin_controller::scan_begin ()
{
    yy_flex_debug = trace_scanning;
    if (file.empty () || file == "-" )
        yyin = stdin;
    else if (!(yyin = fopen (file.c_str (), "r")))
        {
            error ("cannot open " + file + ": " + strerror(errno));
            exit (EXIT_FAILURE);
        }
    yyout = stdout;
}

void
macsin_controller::scan_end ()
{
    fclose (yyin);
}
