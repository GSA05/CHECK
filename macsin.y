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

%token NUM NUM5 FLOAT

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
        | NUM { printf("%d\n",$1); }
        | NUM5 { printf("%d\n",$1); }
        | FLOAT { printf("%g\n",$1); }
        ;
record1: NUM NUM NUM NUM NUM { printf("record1(5)\n"); }
         | NUM NUM NUM NUM NUM NUM { printf("record1(6)\n"); }
         ;
record2: record1 FLOAT { printf("record2\n"); }
         ;
record3: FLOAT
         | record3 FLOAT
         | record2 record3 { printf("record3\n"); }
         ;
record4: ;
record5: ;
record6-11: ;
%%
