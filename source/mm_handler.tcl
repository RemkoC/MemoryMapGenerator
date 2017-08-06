namespace eval nsMemoryMap {
    source "source/mm_tree.tcl"
#    source "source/mm_template_parser.tcl"
    
    #===========================================#
    # Create interface
    #===========================================#
    proc mmInterface {aName aOffset aCode} {
        trCreateTree     $aName interface
        trAddAttribute   offset $aOffset
        trAddAttribute   repeat 1
        trAddAttribute   repeatoffset 0
        eval $aCode
        trUp
    }
    
    #===========================================#
    # Create register
    #===========================================#
    proc mmRegister {aName aOffset aCode} {
        trAddChild       $aName register
        trAddAttribute   offset $aOffset
        trAddAttribute   repeat 1
        trAddAttribute   repeatoffset 0
        eval $aCode
        trUp
    }
    
    #===========================================#
    # Create field
    #===========================================#
    proc mmField {aName aFrom aTo aAccess aCode} {
        trAddChild       $aName field
        trAddAttribute   from   $aFrom
        trAddAttribute   to     $aTo
        trAddAttribute   access $aAccess
        trAddAttribute   repeat 1
        trAddAttribute   repeatoffset 0
        eval $aCode
        trUp
    }
    
    #======================================================================================#
    # Returns the value of the attribute $aKey from node $aNode
    #======================================================================================#
    proc pGetAttribute {aKey {aNode {0 0}}} {
        # switch through virtual attributes, else try to return actual attribute
        switch $aKey {
            DIRECTION {
                set lAccess [trGetAttribute access $aNode]
                
                if [string match "*W*" $lAccess] {
                    return "out"
                } else {
                    return "in"
                }
            }
            VHDLRANGE {
                set lOffset [expr [trGetAttribute repeatoffset $aNode] * [lindex [lindex $aNode end] 0]]
                
                set lFrom [trGetAttribute from $aNode]
                set lTo   [trGetAttribute to   $aNode]
                
                set lFrom [expr $lFrom + $lOffset]
                set lTo   [expr $lTo   + $lOffset]
                
                if {$lFrom == $lTo} {
                    return "(${lTo})"
                } else {
                    return "(${lTo} downto ${lFrom})"
                }
            }
            VHDLTYPE {
                set lFrom [trGetAttribute from $aNode]
                set lTo   [trGetAttribute to   $aNode]
                
                if {$lFrom == $lTo} {
                    return "std_logic"
                } else {
                    return "std_logic_vector([expr $lTo - $lFrom] downto 0)"
                }
            }
            MASK {
                set lOffset [expr [trGetAttribute repeatoffset $aNode] * [lindex [lindex $aNode end] 0]]
                
                set lFrom   [expr $lOffset + [trGetAttribute from $aNode]]
                set lTo     [expr $lOffset + [trGetAttribute to   $aNode]]
                set lMask   0
                
                for {set i $lFrom} {$i <= $lTo} {incr i} {
                    set lMask [expr $lMask + round(pow(2,$i))]
                }
                return $lMask
            }
            default {
                return [trGetAttribute $aKey $aNode]
            }
        }
        return ""
    }
    
    #======================================================================================#
    # Return a list of child-nodes with a type
    #======================================================================================#
    proc pLoopNodes {aKey aMatch {aNode {0}}} {
        return [trLoopNodes $aKey $aMatch $aNode]
    }
    
    namespace export mm*
}

namespace import nsMemoryMap::mm*
#namespace import nsMemoryMap::nsTemplateParser::mmParseFile