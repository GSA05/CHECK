/* Калькулятор для выражени в инфиксной нотации -- calc */

%{
#define YYSTYPE double
#include <math.h>
#include <stdio.h>

int yylex(void);
void yyerror(char *s);
%}

/* Объявления BISON */
%token NUM
%left '-' '+'
%left '*' '/'
%left NEG     /* обращение -- унарный минус */
%right '^'    /* возведение в степень       */

/* Далее следует грамматика */
%%
input:    /* пустая строка */
        | input line
;

line:     '\n'
        | exp '\n'  { printf ("\t%.10g\n", $1); }
;

exp:      NUM                { $$ = $1;         }
        | exp '+' exp        { $$ = $1 + $3;    }
        | exp '-' exp        { $$ = $1 - $3;    }
        | exp '*' exp        { $$ = $1 * $3;    }
        | exp '/' exp        { $$ = $1 / $3;    }
        | '-' exp  %prec NEG { $$ = -$2;        }
        | exp '^' exp        { $$ = pow ($1, $3); }
        | '(' exp ')'        { $$ = $2;         }
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
