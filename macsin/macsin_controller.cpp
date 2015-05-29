#include "macsin_controller.h"
#include "macsin_parser.tab.hh"

macsin_controller::macsin_controller ()
    : trace_scanning (false), trace_parsing (false)
{
    variables["one"] = 1;
    variables["two"] = 2;
}

macsin_controller::~macsin_controller ()
{

}

int
macsin_controller::parse (const std::string &f)
{
    file = f;
    scan_begin ();
    macsin::macsin_parser parser (*this);
    parser.set_debug_level (trace_parsing);
    int res = parser.parse ();
    scan_end ();
    return res;
}

void
macsin_controller::error (const macsin::location &l, const std::string &m)
{
    std::cerr << l << ": " << m << std::endl;
}

void
macsin_controller::error (const std::string &m)
{
    std::cerr << m << std::endl;
}
