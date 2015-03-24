%{
#include <stdio.h>
%}

%option noyywrap
%option prefix="macsin"

int3        [[:digit:]]{1,3}
int5        [[:digit:]]{4,5}
float12     -?[[:digit:]]"."[[:digit:]]{5}[eE][+-][[:digit:]]{2}
comment	    [[:space:]][^{int3}{int5}{float12}]+$

%x comment

%%
{int3}      printf("NUM ");
{int5}      printf("NUM5 ");
{float12}   printf("FLOAT ");
\n          printf("\n");
[ \t]+      /**/;
<<EOF>>     yyterminate();
.           /**/;
%%
