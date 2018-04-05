##  \copyright MIT License. Copyright (c) 2017 R. van Cann.
#   \file       TemplateParser.tcl
#   \author     R. van Cann
#   \brief      Parse a template file containing TCL commands
#   \details    The Template Parser can be used to parse a template file containing TCL commands.

##  \brief      Parse a template file containing TCL commands
#   \details    The Template Parser can be used to parse a template file containing TCL commands.
namespace eval nsTemplateParser {
    namespace export tp*

    variable gFp

    variable gTagOpen   "#TCL"
    variable gTagClose  "TCL#"

    variable gTagTable  {".h" {"/*TCL" "TCL*/"} "default" {"#TCL" "TCL#"}}

    ## \brief   Parses file \c aInput and writes the result to \c aOutput .
    #  \param   aInput      Template file to be parsed.
    #  \param   aOutput     Target file for the results.
    #  \return  Returns 0 on success and 1 on failure.
    #  \details Parses file \c aInput and writes the result to \c aOutput .
    proc tpParse {aInput aOutput} {
        variable gFp
        variable gTagOpen
        variable gTagClose

        # Select opening and closing tags for requested file-format
        SelectTags $aInput

        set fp [open $aInput r]
        set input_data [read $fp]
        close $fp

        # Verify input data
        if {[VerifyInput $input_data]} {
            return 1
        }

        set index       0
        set output_data ""

        set gFp [open $aOutput w]


        while {[string first $gTagOpen $input_data $index] >= 0} {
            set tag_open    [string first $gTagOpen  $input_data $index]
            set tag_close   [string first $gTagClose $input_data $index]
            if {[expr $tag_open + [string length $gTagOpen]] < [expr $tag_close - 1]} {
                set output_data [string cat $output_data "tpPuts \"[string range $input_data $index $tag_open-1]\";"]
                set output_data [string cat $output_data "[string range $input_data $tag_open+[string length $gTagOpen] $tag_close-1]\n"]
                set index [expr $tag_close + [string length $gTagClose]]
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

    ## \brief   Verify template.
    #  \param   aInputBlob      Template to be verified.
    #  \return  Returns 0 on success and 1 on failure.
    #  \details Verifies the template for correct use of opening and closing tags.
    proc VerifyInput {aInputBlob} {
        return 0
    }

    ## \brief   Select opening and closing tags based on
    #  \param   aInputName      Template to be verified.
    #  \return  N/A
    #  \details
    proc SelectTags {aInputName} {
        variable gTagOpen
        variable gTagClose
        variable gTagTable

        if {[dict exists $gTagTable [file extension $aInputName]]} {
            set Tags [dict get $gTagTable [file extension $aInputName]]
        } else {
            set Tags [dict get $gTagTable "default"]
        }

        set gTagOpen  [lindex $Tags 0]
        set gTagClose [lindex $Tags 1]
    }
}

namespace import nsTemplateParser::tp*

# source TemplateParser.tcl; set Name "EntityName"; tpParse "template.vhd" "generated.vhd"
# source TemplateParser.tcl; set Name "EntityName"; tpParse "template.h"   "generated.h"
