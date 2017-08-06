# Source the Memory Map Generator
#
source "source/mm_handler.tcl"

# Source the memory map 
#
source "examples/mm_example.tcl"

# Parse and output the templates
#
mmParseFile "templates/template.vhd"    "generated/interface.vhd"
mmParseFile "templates/template.h"      "generated/interface.h"