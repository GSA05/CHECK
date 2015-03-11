#ifndef CALC_H
#define CALC_H

/* Тип функций.                                      */
typedef double (*func_t) (double);

/* Тип данных для связей в цепочке символов.         */
struct symrec
{
  char *name;  /* имя символа                        */
  int type;    /* тип символа: либо VAR, либо FNCT   */
  union
  {
    double var;                  /* значение VAR     */
    func_t fnctptr;              /* значение FNCT    */
  } value;
  struct symrec *next;    /* поле связи              */
};

typedef struct symrec symrec;

/* Таблица символов: цепочка `struct symrec'.        */
extern symrec *sym_table;

symrec *putsym (const char *, int);
symrec *getsym (const char *);

void init_table(void);

#endif // CALC_H
