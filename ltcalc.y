/* Калькулятор с отслеживанием положений.  */

%{
#define YYSTYPE int
#include <math.h>
#include <stdio.h>
#include <QString>
#include <QTextStream>

QTextStream stream(stdout);

int yylex(void);
void yyerror(char *s);
%}

%token NUM

%left '-' '+'
%left '*' '/'
%left NEG
%right '^'

%% /* Далее следует грамматика */
input   : /* пусто */
        | input line
;

line    : '\n'
        | exp '\n'   { stream<<QString("%1").arg($1)<<endl; }
;

exp     : NUM                { $$ = $1; }
        | exp '+' exp        { $$ = $1 + $3; }
        | exp '-' exp        { $$ = $1 - $3; }
        | exp '*' exp        { $$ = $1 * $3; }
        | exp '/' exp
            {
                if ($3)
                    $$ = $1 / $3;
                else
                    {
                        $$ = 1;
                        stream<<QString("%1.%2-%3.%4: деление на ноль").
                                 arg(@3.first_line).arg(@3.first_column).
                                 arg(@3.last_line).arg(@3.last_column)<<endl;
                    }
            }
        | '-' exp  %prec NEG { $$ = -$2; }
        | exp '^' exp        { $$ = pow ($1, $3); }
        | '(' exp ')'        { $$ = $2; }
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

  /* пропустить промежутки */
  while ((c = getchar ()) == ' ' || c == '\t')
    ++yylloc.last_column;

  /* шаг */
  yylloc.first_line = yylloc.last_line;
  yylloc.first_column = yylloc.last_column;

  /* обработка чисел */
  if (isdigit (c))
    {
      yylval = c - '0';
      ++yylloc.last_column;
      while (isdigit (c = getchar ()))
        {
          ++yylloc.last_column;
          yylval = yylval * 10 + c - '0';
        }
      ungetc (c, stdin);
      return NUM;
    }

  /* вернуть конец файла */
  if (c == EOF)
    return 0;

  /* вернуть однц литеру и обновить положение */
  if (c == '\n')
    {
      ++yylloc.last_line;
      yylloc.last_column = 0;
    }
  else
    ++yylloc.last_column;
  return c;
}

#include <stdio.h>

void
yyerror (char *s)  /* вызывается yyparse в случае ошибки */
{
  stream<<QString("%1").arg(s)<<endl;
}
