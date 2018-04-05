library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity #TCL tpPuts $Name TCL# is
    port (
        iClk             : in    std_logic;
        iReset           : in    std_logic;
        iWrite           : in    std_logic;
        iRead            : in    std_logic;
#TCL for {set i 0} {$i < 4} {incr i} { TCL#        iAddress#TCL tpPuts "$i" TCL#         : in    std_logic_vector(31 downto 0);
#TCL } TCL#        iData            : in    std_logic_vector(31 downto 0);
        oData            : in    std_logic_vector(31 downto 0)
    );
end #TCL tpPuts $Name TCL#;

architecture behave of #TCL tpPuts $Name TCL# is
begin
end behave;
