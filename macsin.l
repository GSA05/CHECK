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

%x row1 row2 row3 row4 row5 material comment isotopes concentrations models isotopes_t concentrations_t temperature groups

%%
                    int line_num = 1;
                    int line_num_prev = 0;
                    int i = 0;
                    int j = 0;
                    int nums[2];
                    int num_group;
                    int mat = -1;
[ \t]               BEGIN(row1); return RECORD1;
<row1>{
    {int3}          macsinlval = atoi(yytext); printf("NUM "); return NUM;
    "\n"            BEGIN(row2); return RECORD2;
}
<row2>{
    {float12}       macsinlval = atof(yytext); printf("FLOAT "); return FLOAT;
    "\n"            BEGIN(row3); return RECORD3;
}
<row3>{
    {float12}       macsinlval = atof(yytext); printf("FLOAT "); return FLOAT;
    "\n"            BEGIN(row4); return RECORD4;
}
<row4>{
    {int3}          macsinlval = atoi(yytext); printf("NUM "); return NUM;
    "\n"            BEGIN(row5); return RECORD5;
}
<row5>{
    {int3}          macsinlval = atoi(yytext); printf("NUM "); return NUM;
    "\n"            BEGIN(material); return RECORD6_11;
}
%%
