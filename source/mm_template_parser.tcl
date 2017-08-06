namespace eval nsTemplateParser {
    namespace import ::nsMemoryMap::mm*
    
    variable gStartCommand "#MM "
    variable gEndCommand   " MM#"
    
    variable gFp
    
    #===========================================#
    # Parse template
    #===========================================#
    proc mmParseFile {aFromFile aToFile} {
        variable gFp
        
        # Get, read and close file
        set fp [open $aFromFile r]
        set file_data [read $fp]
        close $fp
        
        # Split file data in a list of lines
        set lData       [split $file_data "\n"]
        
        # Parse list of lines
        set gFp [open $aToFile w]
        pParseData $lData
        close $gFp
    }

    #===========================================#
    # Parse data for multi-line commands
    #===========================================#
    proc pParseData {aData {aNode {{0 0}}}} {
        variable gStartCommand
        variable gEndCommand
        
        set lDataLength [llength $aData]
        
        set i 0
        while {$i < $lDataLength} {
            set lLine [lindex $aData $i]

            if [string match "${gStartCommand}LOOP *${gEndCommand}" $lLine] {
                set lLoopEnd [pFindCommandEnd [lrange $aData $i end] "LOOP"]
                
                pParseDataLoop [lrange $aData $i+1 [expr $i + $lLoopEnd - 1]] [lindex $lLine 2] [lindex $lLine 3] $aNode
                
                set i [expr $i + $lLoopEnd + 1]
            } else {
                if [string match "${gStartCommand}IF *${gEndCommand}" $lLine] {
                    set lLoopEnd [pFindCommandEnd [lrange $aData $i end] "IF"]
                    pParseDataIf [lrange $aData $i+1 [expr $i + $lLoopEnd - 1]] [lindex $lLine 2] [lindex $lLine 3] $aNode
                    set i [expr $i + $lLoopEnd + 1]
                } else {
                    pParseLine $lLine $aNode
                    incr i
                }
            }
        }
    }

    #===========================================#
    # Parse a line for inline commands
    #===========================================#
    proc pParseLine {aLine aNode} {
        variable gStartCommand
        variable gEndCommand
        variable gFp
        
        set lEnd   0
        
        while {$aLine != {}} {
            if [string match "*${gStartCommand}*" $aLine] {
                set lEnd [string first $gStartCommand $aLine]
                
                if {$lEnd == 0} {
                    if [string match "*${gEndCommand}*" $aLine] {
                        set lEnd [string first $gEndCommand $aLine]
                        
                        pExecuteCommand [string range $aLine 4 $lEnd-1] $aNode
                        set aLine    [string range $aLine $lEnd+4 end]
                    
                    } else {
                        puts -nonewline $gFp    "SYNTAX ERROR: NO COMMAND END!"
                        set aLine ""
                    }
                } else {
                    puts -nonewline $gFp    [string range $aLine 0 $lEnd-1]
                    set aLine               [string range $aLine $lEnd end]
                }
                
            } else {
                puts -nonewline $gFp $aLine
                set aLine ""
            }
        }

        puts $gFp   ""
    }

    #===========================================#
    # Execute multi-line command LOOP
    #===========================================#
    proc pParseDataLoop {aData aKey aMatch aNode} {
        set lDataLength [llength $aData]
        
        set lNodeList [nsMemoryMap::pLoopNodes $aKey $aMatch $aNode]
        
#        puts $lNodeList
        
        foreach lNode $lNodeList {
            set lRepeat [list]
            pParseData $aData $lNode
        }
    }

    #===========================================#
    # Execute multi-line command IF
    #===========================================#
    proc pParseDataIf {aData aType aMatch aNode} {
        
        set lAttribute [::nsMemoryMap::pGetAttribute $aType $aNode]
        
        if [string match $aMatch $lAttribute] {
            pParseData $aData $aNode
        }
    }

    #===========================================#
    # Find end of multi-line command
    #===========================================#
    proc pFindCommandEnd {aData aCommand} {
        variable gStartCommand
        variable gEndCommand
        
        set lDataLength [llength $aData]
        set lCounter 0
        
        for {set i 1} {$i < $lDataLength} {incr i} {
            set lLine [lindex $aData $i]
            if [string match "#MM ${aCommand} * MM#" $lLine] {
                incr lCounter
            }
            if [string match "#MM END${aCommand} MM#" $lLine] {
                if {$lCounter == 0} {
                    return $i
                }
                set lCounter [expr $lCounter - 1]
            }
        }
        puts "ERROR: MULTI-LINE COMMAND END NOT FOUND!"
    }

    #===========================================#
    # Execute an inline command
    #===========================================#
    proc pExecuteCommand {lCommand aNode} {
        variable gFp
        
        if {[lindex $lCommand 0] == ""} {
            puts -nonewline "SYNTAX ERROR: NO COMMAND!"
            return
        }
        
        switch [lindex $lCommand 0] {
            PUTS {
                if {[llength $lCommand] == 3} {
                    set lFormat [lindex $lCommand 2]
                } else {
                    set lFormat "%s"
                }
                puts -nonewline $gFp [format $lFormat [::nsMemoryMap::pGetAttribute [lindex $lCommand 1] $aNode]]
            }
            default         {puts -nonewline "ERROR: UNKNOWN COMMAND!"}
        }
    }
    
    namespace export mmParseFile
}
