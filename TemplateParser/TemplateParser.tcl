##  \copyright  MIT License
#               
#               Copyright (c) 2017 R. van Cann
#               
#               Permission is hereby granted, free of charge, to any person obtaining a copy
#               of this software and associated documentation files (the "Software"), to deal
#               in the Software without restriction, including without limitation the rights
#               to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#               copies of the Software, and to permit persons to whom the Software is
#               furnished to do so, subject to the following conditions:
#               
#               The above copyright notice and this permission notice shall be included in all
#               copies or substantial portions of the Software.
#               
#               THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#               IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#               FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#               AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#               LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#               OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#               SOFTWARE.
#   \file       TemplateParser.tcl
#   \author     R. van Cann
#   \brief      Parse a template file containing TCL commands
#   \details    The Template Parser can be used to parse a template file containing TCL commands.

##  \brief      Parse a template file containing TCL commands
#   \details    The Template Parser can be used to parse a template file containing TCL commands.
namespace eval nsTemplateParser {
    namespace export tp*
    
    variable gFp

    ## \brief   Parses file \c aInput and writes the result to \c aOutput .
    #  \param   aInput      Template file to be parsed.
    #  \param   aOutput     Target file for the results.
    #  \return  Returns 0 on success and 1 on failure.
    #  \details Parses file \c aInput and writes the result to \c aOutput .
    proc tpParse {aInput aOutput} {
        variable gFp
        
        set fp [open $aInput r]
        set input_data [read $fp]
        close $fp
        
        set index       0
        set output_data ""
        
        set gFp [open $aOutput w]
        
        
        while {[string first "#TCL" $input_data $index] >= 0} {
            set tag_open    [string first "#TCL" $input_data $index]
            set tag_close   [string first "TCL#" $input_data $index]
            if {[expr $tag_open + 4] < [expr $tag_close - 1]} {
                set output_data [string cat $output_data "tpPuts \"[string range $input_data $index $tag_open-1]\";"]
                set output_data [string cat $output_data "[string range $input_data $tag_open+4 $tag_close-1]\n"]
                set index [expr $tag_close + 4]
            } else {
                close $gFp
                return 1
            }
        }
        
        set output_data [string cat $output_data "tpPuts \"[string range $input_data $index end]\";"]
        
        uplevel 1 $output_data
        
        close $gFp
        return 0
    }
    
    ## \brief   Writes a string to the file \c aOutput in procedure \c tpParse .
    #  \param   aString     String to be written to the generated file.
    #  \details Writes a string to the file \c aOutput in procedure \c tpParse . Only call this
    #           function from the template file \c aInput in procedure \c tpParse or from
    #           \c tpParse itself **in between** opening and closing file \c aOutput .
    proc tpPuts {aString} {
        variable gFp
        puts -nonewline $gFp $aString
    }
}

namespace import nsTemplateParser::tp*

#set Name "EntityName"
#tpParse "template.vhd" "generated.vhd"