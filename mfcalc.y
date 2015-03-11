%{
#include <math.h>  /* Математические функции: cos(), sin() и т.д. */
#include <stdio.h>
#include "calc.h"  /* Содержит определение `symrec'               */

int yylex(void);
void yyerror(const char *);
%}
%union {
double     val;  /* Чтобы возвращать числа.                     */
symrec  *tptr;   /* Чтобы возвращать указатели таблицы символов */
}

%token <val>  NUM        /* Простое число двойной точности   */
%token <tptr> VAR FNCT   /* Переменная и функция             */
%type  <val>  exp

%right '='
%left '-' '+'
%left '*' '/'
%left NEG     /* Обращение -- унарный минус */
%right '^'    /* Возведение в степень       */

/* Далее следует грамматика */

%%
input:   /* пусто */
        | input line
;

line:
          '\n'
        | exp '\n'   { printf ("\t%.10g\n", $1); }
        | error '\n' { yyerrok;                  }
;

exp:      NUM                { $$ = $1;                         }
        | VAR                { $$ = $1->value.var;              }
        | VAR '=' exp        { $$ = $3; $1->value.var = $3;     }
        | FNCT '(' exp ')'   { $$ = (*($1->value.fnctptr))($3); }
        | exp '+' exp        { $$ = $1 + $3;                    }
        | exp '-' exp        { $$ = $1 - $3;                    }
        | exp '*' exp        { $$ = $1 * $3;                    }
        | exp '/' exp        { $$ = $1 / $3;                    }
        | '-' exp  %prec NEG { $$ = -$2;                        }
        | exp '^' exp        { $$ = pow ($1, $3);               }
        | '(' exp ')'        { $$ = $2;                         }
;
/* End of grammar */
%%
#include <ctype.h>
#include <string.h>

void
yyerror (const char *s)  /* Вызывается yyparse в случае ошибки */
{
  printf ("%s\n", s);
}

struct init
{
  char *fname;
  double (*fnct)(double);
};

struct init arith_fncts[] =
{
  "sin",  sin,
  "cos",  cos,
  "atan", atan,
  "ln",   log,
  "exp",  exp,
  "sqrt", sqrt,
  0, 0
};

/* Таблица символов: цепочка `struct symrec'.  */
symrec *sym_table = (symrec *) 0;

/* Поместить арифметические функции в таблицу. */
void
init_table (void)
{
  int i;
  symrec *ptr;
  for (i = 0; arith_fncts[i].fname != 0; i++)
    {
      ptr = putsym (arith_fncts[i].fname, FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }
}

symrec *
putsym (const char *sym_name, int sym_type)
{
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->type = sym_type;
  ptr->value.var = 0; /* set value to 0 even if fctn.  */
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *
getsym (const char *sym_name)
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name,sym_name) == 0)
      return ptr;
  return 0;
}

int
yylex (void)
{
  int c;

  /* Игнорировать промежутки, получить первый непробельный символ.  */
  while ((c = getchar ()) == ' ' || c == '\t');

  if (c == EOF)
    return 0;

  /* С литеры начинается число => разобрать число.                  */
  if (c == '.' || isdigit (c))
    {
      ungetc (c, stdin);
      scanf ("%lf", &yylval.val);
      return NUM;
    }

  /* С литеры начинается идентификатор => читать имя.              */
  if (isalpha (c))
    {
      symrec *s;
      static char *symbuf = 0;
      static int length = 0;
      int i;

      /* Первоначально сделать буфер достаточно большим
         для имени символа из 40 литер.  */
      if (length == 0)
        length = 40, symbuf = (char *)malloc (length + 1);

      i = 0;
      do
        {
          /* Если буфер полон, расширить его.          */
          if (i == length)
            {
              length *= 2;
              symbuf = (char *)realloc (symbuf, length + 1);
            }
          /* Добавить эту литеру в буфер.              */
          symbuf[i++] = c;
          /* Получить следующую литеру.                */
          c = getchar ();
        }
      while (c != EOF && isalnum (c));

      ungetc (c, stdin);
      symbuf[i] = '\0';

      s = getsym (symbuf);
      if (s == 0)
        s = putsym (symbuf, VAR);
      yylval.tptr = s;
      return s->type;
    }

  /* Любая другая литера сама по себе является лексемой.        */
  return c;
}
