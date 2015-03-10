#include <QCoreApplication>
#include "rpcalc.hpp"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    yyparse();

    return a.exec();
}
