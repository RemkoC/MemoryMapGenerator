# Source the Memory Map Generator
#
source "source/mm_handler.tcl"

source "source/mm_template_parser.tcl"
namespace import nsTemplateParser::mmParseFile

# Source the memory map 
#
source "examples/mm_example.tcl"

# Parse and output the templates
#
mmParseFile "templates/template.vhd"    "generated/interface.vhd"
mmParseFile "templates/template.h"      "generated/interface.h"