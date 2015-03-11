#include <QCoreApplication>
#include "calc.h"
#include "rpcalc.hpp"
#include <clocale>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    setlocale(LC_CTYPE,"Russian");
    init_table();
    //yylloc.first_line = yylloc.last_line = 1;
    //yylloc.first_column = yylloc.last_column = 0;
    yyparse();

    return a.exec();
}
