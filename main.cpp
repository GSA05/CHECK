#include <QCoreApplication>
//#include "macsin.tab.h"
#include <clocale>

extern FILE *macsinin;
extern "C" int macsinparse();

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    setlocale(LC_CTYPE,"Russian");
    ++argv, --argc;
    while (argc-- > 0) {
        macsinin = fopen(argv[0]++,"r");
        macsinparse();
    }

    return a.exec();
}
