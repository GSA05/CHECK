#include <iostream>
#include "macsin/macsin_controller.h"

using namespace std;

int main(int argc, char *argv[])
{
    int res = 0;
    macsin_controller macsin;
    for (int i = 1; i < argc; i++)
        if (argv[i] == std::string ("-p"))
            macsin.trace_parsing = true;
        else if (argv[i] == std::string ("-s"))
            macsin.trace_scanning = true;
        else if (!macsin.parse (argv[i]))
            std::cout << macsin.result << std::endl;
        else
            res = 1;
    return res;
}

