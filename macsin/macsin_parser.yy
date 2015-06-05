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
int d = 0;
}
%define api.token.prefix {TOK_}
%token
    NUM
    NUM5
    FLOAT
    RECORD1
    RECORD2
    RECORD3
    RECORD4
    RECORD5
    RECORD6_11
    MATERIALS
    MATERIAL
    ISOTOPES
    CONCENTRATIONS
    MODELS
    ISOTOPES_T
    CONCENTRATIONS_T
    TEMPERATURE
    GROUPS
    BAD
    END 0
;
%type <int> NUM, NUM5
%type <float> FLOAT
%printer { yyoutput << $$; } <*>;
%%
%start records;
records: /* */
         | records record
         | records error record
         | records END
         ;
record: record1
        | record2
        | record3
        | record4
        | record5
        | record6-11
        ;
record1: RECORD1
         | record1 NUM
         ;
record2: RECORD2 { if (d) { printf("record1\n"); } }
         | record2 FLOAT
         ;
record3: RECORD3 { if (d) { printf("record2\n"); } }
         | record3 FLOAT
         ;
record4: RECORD4 { if (d) { printf("record3\n"); } }
         | record4 NUM
         ;
record5: RECORD5 { if (d) { printf("record4\n"); } }
         | record5 NUM
         ;
material: MATERIAL
          | material NUM
          ;
isotopes: ISOTOPES { if (d) { printf("material\n"); } }
          | isotopes NUM5
          ;
concentrations: CONCENTRATIONS { if (d) { printf("isotopes\n"); } }
                | concentrations FLOAT
                ;
models: MODELS { if (d) { printf("concentrations\n"); } }
        | models NUM
        ;
isotopes_t: ISOTOPES_T { if (d) { printf("models\n"); } }
            | isotopes_t NUM5
            ;
concentrations_t: CONCENTRATIONS_T { if (d) { printf("isotopes_t\n"); } }
                  | concentrations_t FLOAT
                  ;
temperature: TEMPERATURE { if(1) if (d) { printf("models\n"); } else if (d) { printf("concentrations_t\n"); } }
             | temperature FLOAT
             ;
groups: GROUPS { if (d) { printf("temperature\n"); } }
        | groups NUM;
record6-11: MATERIALS { if (d) { printf("record5\n"); } }
            | record6-11 material isotopes concentrations models isotopes_t concentrations_t temperature groups { if (d) { printf("groups\n"); } }
            | record6-11 material isotopes concentrations models temperature groups { if (d) { printf("groups\n"); } }
            ;
%%
void
macsin::macsin_parser::error (const location_type& l,
                          const std::string& m)
{
    controller.error (l, m);
}
