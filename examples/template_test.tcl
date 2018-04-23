# Source the Memory Map Generator
#
source "../source/TemplateParser.tcl"

set Name "TestName"

nsTemplateParser::tpParse ../templates/template.vhd generated.vhd
nsTemplateParser::tpParse ../templates/template.h   generated.h
