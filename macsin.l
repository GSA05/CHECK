%{
#include <stdio.h>
#include "macsin.tab.h"
%}

%option noyywrap
%option prefix="macsin"

int3        [[:digit:]]{1,3}
int5        [[:digit:]]{4,5}
float12     -?[[:digit:]]"."[[:digit:]]{5}[eE][+-][[:digit:]]{2}
comment	    [[:space:]][^{int3}{int5}{float12}]+$

%x comment

%%
{int3}      macsinlval = atoi(yytext); printf("NUM "); return NUM;
{int5}      macsinlval = atoi(yytext); printf("NUM5 "); return NUM5;
{float12}   printf("FLOAT "); return FLOAT;
\n          printf("\n");
[ \t]+      /**/;
<<EOF>>     yyterminate();
.           /**/;
%%
