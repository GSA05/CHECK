%{
#include <stdio.h>
#include "main.h"

extern int d;
%}

%option prefix="macsin"

int3        [[:digit:]]{1,3}
int5        [[:digit:]]{3,5}
float12     -?[[:digit:]]"."[[:digit:]]{5}[eE][+-][[:digit:]]{2}
comment	    [[:space:]][^{int3}{int5}{float12}]+$

%x row1 row2 row3 row4 row5 materials material comment isotopes concentrations models isotopes_t concentrations_t temperature groups

%%
                    static int i = 0;
                    int j = 0;
                    static int nums[2];
[ \t]               BEGIN(row1); return RECORD1;
<row1>{
    {int3}          macsinlval = atoi(yytext); if (d) printf("NUM "); return NUM;
    "\n"            BEGIN(row2); return RECORD2;
}
<row2>{
    {float12}       macsinlval = atof(yytext); if (d) printf("FLOAT "); return FLOAT;
    "\n"            BEGIN(row3); return RECORD3;
}
<row3>{
    {float12}       macsinlval = atof(yytext); if (d) printf("FLOAT "); return FLOAT;
    "\n"            BEGIN(row4); return RECORD4;
}
<row4>{
    {int3}          macsinlval = atoi(yytext); if (d) printf("NUM "); return NUM;
    "\n"            BEGIN(row5); return RECORD5;
}
<row5>{
    {int3}          macsinlval = atoi(yytext); if (d) printf("NUM "); return NUM;
    "\n"            BEGIN(materials); return MATERIALS;
}
<materials>[ \t]    BEGIN(material); return MATERIAL;
<material>{
    {int3}          macsinlval = nums[i] = atoi(yytext); if (d) printf("NUM "); if(++i == 2) BEGIN(comment); return NUM;
}
<comment>.*"\n"     i = 0; BEGIN(isotopes); return ISOTOPES;
<isotopes>{
    {int5}          i++; macsinlval = atoi(yytext); if (d) printf("NUM5 "); return NUM5;
    "\n"            if(i >= nums[0]) { i = 0; BEGIN(concentrations); return CONCENTRATIONS; }
}
<concentrations>{
    {float12}       i++; macsinlval = atof(yytext); if (d) printf("FLOAT "); return FLOAT;
    "\n"            if(i >= nums[0]) { i = 0; BEGIN(models); return MODELS; }
}
<models>{
    {int3}          i++; macsinlval = atoi(yytext); if (d) printf("NUM "); return NUM;
    "\n"            if(i >= nums[0]) { i = 0; if(nums[1]) { BEGIN(isotopes_t); return ISOTOPES_T; } else { BEGIN(temperature); return TEMPERATURE; } }
}
<isotopes_t>{
    {int5}          i++; macsinlval = atoi(yytext); if (d) printf("NUM5 "); return NUM5;
    "\n"            if(i >= nums[1]) { i = 0; BEGIN(concentrations_t); return CONCENTRATIONS_T; }
}
<concentrations_t>{
    {float12}       i++; macsinlval = atof(yytext); if (d) printf("FLOAT "); return FLOAT;
    "\n"            if(i >= nums[1]) { i = 0; BEGIN(temperature); return TEMPERATURE; }
}
<temperature>{
    {float12}       macsinlval = atof(yytext); if (d) printf("FLOAT "); return FLOAT;
    "\n"            i = 0; BEGIN(groups); return GROUPS;
}
<groups>{
    {int3}          macsinlval = atoi(yytext); if (d) printf("NUM "); return NUM;
    "\n"            if(++i == nums[0]) { i = 0; BEGIN(material); return MATERIAL; }
}
<<EOF>>             yyterminate(); return 0;
<*>[ \t\r\n]
<*>.                return BAD;

%%
