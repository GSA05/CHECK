#include <QCoreApplication>
#include "rpcalc.hpp"
#include <clocale>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    setlocale(LC_CTYPE,"Russian");
    yylloc.first_line = yylloc.last_line = 1;
    yylloc.first_column = yylloc.last_column = 0;
    yyparse();

    return a.exec();
}
