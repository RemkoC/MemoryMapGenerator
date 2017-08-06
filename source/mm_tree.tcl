namespace eval nsTree {
    variable gTree {{} {}}
    variable gCurrentNode ""
    
    ########################################
    # Helper function: return node template
    ########################################
    proc pCreateNode {aName aNodeType} {
        set lNode [list]
        
        lset lNode 0 [dict create name $aName type $aNodeType]
        lset lNode 1 [list]
        
        trAddAttribute $aName $aNodeType
        
        return $lNode
    }

    ########################################
    # Clear current tree
    ########################################
    proc trCreateTree {aName aNodeType} {
        variable gTree
        variable gCurrentNode
        
        set gCurrentNode ""
        set gTree [pCreateNode $aName $aNodeType]
    }

    ########################################
    # Add new attribute to current node
    ########################################
    proc trAddAttribute {aKey aContent} {
        variable gTree
        variable gCurrentNode
        
        set lCurrentNode $gCurrentNode
        lappend lCurrentNode 0
        
        set lAttributes [lindex $gTree $lCurrentNode]
        dict set lAttributes $aKey $aContent
        lset gTree $lCurrentNode $lAttributes

        #puts $gTree
    }
    
    
    
    
    
    ################################################################################
    # Get information functions
    ################################################################################
    
    proc pGetSubTree {aTree aNode} {
        set lSubTree $aTree
        
#        foreach {lRepeat lFirst lSecond} [lrange $aNode 0 end-1] {
#            set lSubTree [lindex $lSubTree $lFirst]
#            set lSubTree [lindex $lSubTree $lSecond]
#        }
        
        foreach {lFirst lSecond lRepeat} [lrange $aNode 1 end] {
            set lSubTree [lindex $lSubTree $lFirst]
            set lSubTree [lindex $lSubTree $lSecond]
        }
        
        return $lSubTree
    }
    
    # Get the value of attribute $aKey from node $aNode
    proc trGetAttribute {aKey {aNode {{0 0}}}} {
        variable gTree
#        puts "Test: $aKey"
        set lTree   [pGetSubTree $gTree $aNode]
        set lReturn [dict get [lindex $lTree 0] $aKey]
        switch $aKey {
            name {
                set lNumber -1
                
                foreach {lFirst lSecond lRepeat} [lrange $aNode 1 end] {
                    if {[lindex $lRepeat 1] > 1} {
                        if {$lNumber == -1} {
                            set lNumber 0
                        }
                        
                        set lNum0 [lindex $lRepeat 0]
                        set lNum1 [lindex $lRepeat 1]
                        
                        set lNumber [expr $lNumber * $lNum1 + $lNum0]
                    }
                }
                
                if {$lNumber >= 0} {
                    set lReturn "${lReturn}_${lNumber}"
                }
            }
            offset {
                set lNumber 0
                
                #set lList0 [list]
                #set lList1 [list]
                
                foreach {lFirst lSecond lRepeat} [lrange $aNode 1 end] {
                    if {[lindex $lRepeat 1] > 1} {
                        #lappend lList0 [lindex $lRepeat 0]
                        #lappend lList1 [lindex $lRepeat 1]
                        
                        set lNum0 [lindex $lRepeat 0]
                        set lNum1 [lindex $lRepeat 1]
                        
                        set lNumber [expr $lNumber * $lNum1 + $lNum0]
                    }
                }
                
                set lNumber [expr $lNumber * 4]
                
                set lReturn [expr $lReturn + $lNumber]
            }
            default {
            }
        }
        
        return $lReturn
    }
    
    
    # Returns a list of all nodes descending from $aNode with attribute type equal to $aType
    proc trLoopNodes {aKey aMatch {aNode {{0 0}}}} {
        variable gTree
        
        set lReturn [list]
        set lTree   [pGetSubTree $gTree $aNode]
        
        set lAttribute [lindex $lTree 0]
        set lChildren  [lindex $lTree 1]
        set lChildrenLength [llength $lChildren]
        
        # If current node fits the criteria, add to the return value
        if {[dict get $lAttribute $aKey] == $aMatch} {
            set     lReturn "{$aNode}"
        }
        
        # Look for all child-nodes for node that fit the criteria
        for {set i 0} {$i < $lChildrenLength} {incr i} {
            set lChildNode  [concat $aNode 1 $i 0]
            set lTree2      [pGetSubTree $gTree $lChildNode]
            set lAttribute2 [lindex $lTree2 0]
            set lNrNodes [dict get $lAttribute2 repeat]
            set lChildNode  [concat $aNode 1 $i 0]
            
            for {set j 0} {$j < $lNrNodes} {incr j} {
                #set lChildNode [concat $aNode 1 $i $j]
                #set lChildNode [concat $aNode 1 $i 0]
                set lChildNode "$aNode 1 $i {$j $lNrNodes}"
                
                set lTemp [trLoopNodes $aKey $aMatch $lChildNode]
                
                if {$lTemp != ""} {
                    if {[info exists lReturn]} {
                        set lReturn [concat $lReturn $lTemp]
                    } else {
                        set lReturn [concat $lReturn $lTemp]
                    }
                }
            }
        }
        
        if {[info exists lReturn]} {
            return $lReturn
        } else {
            return ""
        }
    }
    

    ########################################
    # Add new child to current node
    ########################################
    proc trAddChild {aName aNodeType} {
        variable gTree
        variable gCurrentNode
        
        # Change current location to new location
        lappend gCurrentNode 1
        set     lChildren    [lindex $gTree $gCurrentNode]
        set     lNrChildren  [llength $lChildren]
        lappend gCurrentNode $lNrChildren
        
        # Add new node at new location
        lset gTree $gCurrentNode [pCreateNode $aName $aNodeType]
    }
    
    ########################################
    # Goto the parent node
    ########################################
    proc trUp {} {
        variable gCurrentNode
        
        set gCurrentNode [lreplace $gCurrentNode end-1 end]
    }
    
#    ########################################
#    # Goto the child node
#    ########################################
#    proc trDown {aIndex} {
#        variable gCurrentNode
#        
#        lappend gCurrentNode 1 $aIndex
#    }
    
#    ########################################
#    # Goto the root node
#    ########################################
#    proc trRoot {} {
#        variable gCurrentNode
#        
#        set gCurrentNode {}
#    }
    
    ########################################
    # Display tree for debug purposes
    ########################################
    proc trPrintTree {} {
        variable gTree
        
        pPrintTreeLoop $gTree ""
    }
    
    proc pPrintTreeLoop {aTree aIndent} {
        
        set lAttribute [lindex $aTree 0]
        set lChildren  [lindex $aTree 1]
        
        puts "${aIndent}[dict get $lAttribute name] ([dict get $lAttribute type])"
        
        foreach lChild $lChildren {
            pPrintTreeLoop $lChild "${aIndent}    "
        }
    }
    
    ########################################
    # Export current tree
    ########################################
    proc trSerializeTree {} {
        variable gTree
        return $gTree
    }
    
    ########################################
    # Import existing tree
    ########################################
    proc trDeserializeTree {aTree} {
        variable gTree
        set gTree $aTree
    }
    
    namespace export tr*
}

namespace import nsTree::tr*