%{ /* -*- C++ -*- */
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <string>
#include "macsin_controller.h"
#include "macsin_parser.tab.hh"

extern int d;
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

int3    [[:digit:]]{1,3}
int5    [[:digit:]]{3,5}
float12 -?[[:digit:]]"."[[:digit:]]{5}[eE][+-][[:digit:]]{2}
comment	[[:space:]][^{int3}{int5}{float12}]+$
blank   [ \t]

%x row1 row2 row3 row4 row5 materials material comment isotopes concentrations models isotopes_t concentrations_t temperature groups
%{
    // Code run each time a pattern is matched.
    #define YY_USER_ACTION loc.columns (yyleng);
%}
%%
%{
    // Code run each time yylex is called.
    loc.step ();
%}
    static int i = 0;
    static int nums[2];
{blank}         loc.step (); BEGIN(row1); return macsin::macsin_parser::make_RECORD1(loc);
<row1,row2>{
{int3}          if (d) printf("NUM "); return macsin::macsin_parser::make_NUM(atoi(yytext),loc);
"\n"            BEGIN(row2); return macsin::macsin_parser::make_RECORD2(loc);
}
<row2>{
{float12}       if (d) printf("FLOAT "); return macsin::macsin_parser::make_FLOAT(atof(yytext),loc);
"\n"            BEGIN(row3); return macsin::macsin_parser::make_RECORD3(loc);
}
<row3>{
{float12}       if (d) printf("FLOAT "); return macsin::macsin_parser::make_FLOAT(atof(yytext),loc);
"\n"            BEGIN(row4); return macsin::macsin_parser::make_RECORD4(loc);
}
<row4>{
{int3}          if (d) printf("NUM "); return macsin::macsin_parser::make_NUM(atoi(yytext),loc);
"\n"            BEGIN(row5); return macsin::macsin_parser::make_RECORD5(loc);
}
<row5>{
{int3}          if (d) printf("NUM "); return macsin::macsin_parser::make_NUM(atoi(yytext),loc);
"\n"            BEGIN(materials); return macsin::macsin_parser::make_MATERIALS(loc);
}
<materials>{blank}    BEGIN(material); return macsin::macsin_parser::make_MATERIAL(loc);
<material>{
{int3}          nums[i] = atoi(yytext); if (d) printf("NUM "); if(++i == 2) BEGIN(comment); return macsin::macsin_parser::make_NUM(atoi(yytext),loc);
}
<comment>.*"\n"     i = 0; BEGIN(isotopes); return macsin::macsin_parser::make_ISOTOPES(loc);
<isotopes>{
{int5}          i++; if (d) printf("NUM5 "); return macsin::macsin_parser::make_NUM5(atoi(yytext),loc);
"\n"            if(i >= nums[0]) { i = 0; BEGIN(concentrations); return macsin::macsin_parser::make_CONCENTRATIONS(loc); }
}
<concentrations>{
{float12}       i++; if (d) printf("FLOAT "); return macsin::macsin_parser::make_FLOAT(atof(yytext),loc);
"\n"            if(i >= nums[0]) { i = 0; BEGIN(models); return macsin::macsin_parser::make_MODELS(loc); }
}
<models>{
{int3}          i++; if (d) printf("NUM "); return macsin::macsin_parser::make_NUM(atoi(yytext),loc);
"\n"            if(i >= nums[0]) { i = 0; if(nums[1]) { BEGIN(isotopes_t); return macsin::macsin_parser::make_ISOTOPES_T(loc); } else { BEGIN(temperature); return macsin::macsin_parser::make_TEMPERATURE(loc); } }
}
<isotopes_t>{
{int5}          i++; if (d) printf("NUM5 "); return macsin::macsin_parser::make_NUM5(atoi(yytext),loc);
"\n"            if(i >= nums[1]) { i = 0; BEGIN(concentrations_t); return macsin::macsin_parser::make_CONCENTRATIONS_T(loc); }
}
<concentrations_t>{
{float12}       i++; if (d) printf("FLOAT "); return macsin::macsin_parser::make_FLOAT(atof(yytext),loc);
"\n"            if(i >= nums[1]) { i = 0; BEGIN(temperature); return macsin::macsin_parser::make_TEMPERATURE(loc); }
}
<temperature>{
{float12}       if (d) printf("FLOAT "); return macsin::macsin_parser::make_FLOAT(atof(yytext),loc);
"\n"            i = 0; BEGIN(groups); return macsin::macsin_parser::make_GROUPS(loc);
}
<groups>{
{int3}          if (d) printf("NUM "); return macsin::macsin_parser::make_NUM(atoi(yytext),loc);
"\n"            if(++i == nums[0]) { i = 0; BEGIN(material); return macsin::macsin_parser::make_MATERIAL(loc); }
}
<<EOF>>         return macsin::macsin_parser::make_END(loc);
<*>[ \t\r\n]
%<*>.                return macsin::macsin_parser::make_BAD(loc);
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
}

void
macsin_controller::scan_end ()
{
    fclose (yyin);
}
