%{
#include <stdio.h>
#include <string.h>

void macsinerror(const char *str)
{
        fprintf(stderr,"Error: %s\n",str);
}

int macsinwrap()
{
        return 1;
}
%}

%name-prefix "macsin"

%token NUM NUM5 FLOAT RECORD1 RECORD2 RECORD3 RECORD4 RECORD5 RECORD6_11 MATERIALS MATERIAL ISOTOPES CONCENTRATIONS MODELS ISOTOPES_T CONCENTRATIONS_T TEMPERATURE GROUPS

%%
records: /* */
         | records record
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
record2: RECORD2 { printf("record1\n"); }
         | record2 FLOAT
         ;
record3: RECORD3 { printf("record2\n"); }
         | record3 FLOAT
         ;
record4: RECORD4 { printf("record3\n"); }
         | record4 NUM
         ;
record5: RECORD5 { printf("record4\n"); }
         | record5 NUM
         ;
material: MATERIAL
          | material NUM
          ;
isotopes: ISOTOPES { printf("material\n"); }
          | isotopes NUM5
          ;
concentrations: CONCENTRATIONS { printf("isotopes\n"); }
                | concentrations FLOAT
                ;
models: MODELS { printf("concentrations\n"); }
        | models NUM
        ;
isotopes_t: ISOTOPES_T { printf("models\n"); }
            | isotopes NUM5
            ;
concentrations_t: CONCENTRATIONS_T { printf("isotopes_t\n"); }
                  | concentrations_t FLOAT
                  ;
temperature: TEMPERATURE { if(1) printf("models\n"); else printf("concentrations_t"); }
             | temperature FLOAT
             ;
record6-11: MATERIALS { printf("record5\n"); }
            | record6-11 material isotopes concentrations models isotopes_t concentrations_t temperature
            | record6-11 material isotopes concentrations models temperature
            ;
%%
