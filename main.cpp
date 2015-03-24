#include <QCoreApplication>
//#include "macsin.tab.h"
#include <clocale>

extern FILE *macsinin;
//extern "C" int macsinlex(void);
extern "C" int macsinparse();

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    setlocale(LC_CTYPE,"Russian");
    //init_table();
    //yylloc.first_line = yylloc.last_line = 1;
    //yylloc.first_column = yylloc.last_column = 0;
    //yyparse();
    ++argv, --argc;
    if (argc > 0) {
        macsinin = fopen(argv[0],"r");
    }
    else {
        macsinin = stdin;
    }
    macsinparse();

    return a.exec();
}
