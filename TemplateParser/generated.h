library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EntityName is
    port (
        iClk             : in    std_logic;
        iReset           : in    std_logic;
        iWrite           : in    std_logic;
        iRead            : in    std_logic;
#define test0 0
#define test1 0
#define test2 0
#define test3 0
        iData            : in    std_logic_vector(31 downto 0);
        oData            : in    std_logic_vector(31 downto 0)
    );
end EntityName;

architecture behave of EntityName is
begin
end behave;
