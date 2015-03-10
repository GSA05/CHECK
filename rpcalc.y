/* Калькулятор обратной польской нотации. */

%{
#define YYSTYPE double
#include <math.h>
#include <stdio.h>

int yylex(void);
void yyerror(char *s);
%}

%token NUM

%% /* Далее следуют правила грамматики и действия */
input:    /* пусто */
        | input line
;

line:     '\n'
        | exp '\n'  { printf ("\t%.10g\n", $1); }
;

exp:      NUM             { $$ = $1;         }
        | exp exp '+'     { $$ = $1 + $2;    }
        | exp exp '-'     { $$ = $1 - $2;    }
        | exp exp '*'     { $$ = $1 * $2;    }
        | exp exp '/'     { $$ = $1 / $2;    }
      /* возведение в степень */
        | exp exp '^'     { $$ = pow ($1, $2); }
      /* унарный минус        */
        | exp 'n'         { $$ = -$1;        }
;
%%
/* Лексический анализатор возвращает вещественное число
   с двойной точностью в стеке и лексему NUM, или прочитанную
   литеру ASCII, если это не число. Все пробелы и знаки
   табуляции пропускаются, в случае конца файла возвращается 0. */

#include <ctype.h>

int
yylex (void)
{
  int c;

  /* пропустить промежутки  */
  while ((c = getchar ()) == ' ' || c == '\t')
    ;
  /* обработка чисел       */
  if (c == '.' || isdigit (c))
    {
      ungetc (c, stdin);
      scanf ("%lf", &yylval);
      return NUM;
    }
  /* вернуть конец файла  */
  if (c == EOF)
    return 0;
  /* вернуть одну литеру */
  return c;
}

#include <stdio.h>

void
yyerror (char *s)  /* вызывается yyparse в случае ошибки */
{
  printf ("%s\n", s);
}
