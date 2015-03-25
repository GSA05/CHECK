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

%token NUM NUM5 FLOAT RECORD1 RECORD2 RECORD3 RECORD4 RECORD5 RECORD6_11

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
        /* | NUM { printf("%d\n",$1); }
        | NUM5 { printf("%d\n",$1); }
        | FLOAT { printf("%g\n",$1); } */
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
record6-11: RECORD6_11 { printf("record5\n"); }
            ;
%%
