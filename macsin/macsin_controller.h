#ifndef MACSIN_CONTROLLER_H
#define MACSIN_CONTROLLER_H
#include <string>
#include <map>
#include "controller.h"
#include "macsin_parser.tab.hh"
// Tell Flex the lexer's prototype ...
#define YY_DECL \
    macsin::macsin_parser::symbol_type yylex (macsin_controller& controller)
// ... and declare it for the parser's sake.
YY_DECL;
// Conducting the whole scanning and parsing of Calc++.
class macsin_controller : public controller
{
public:
    macsin_controller ();
    virtual ~macsin_controller ();

    std::map<std::string, int> variables;

    int result;
    // Handling the scanner.
    void scan_begin ();
    void scan_end ();
    bool trace_scanning;
    // Run the parser on file F.
    // Return 0 on success.
    int parse (const std::string& f);
    // The name of the file being parsed.
    // Used later to pass the file name to the location tracker.
    std::string file;
    // Whether parser traces should be generated.
    bool trace_parsing;
    // Error handling.
    void error (const macsin::location& l, const std::string& m);
    void error (const std::string& m);
};
#endif // MACSIN_CONTROLLER_H
