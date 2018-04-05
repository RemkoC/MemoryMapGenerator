library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EntityName is
    port (
        iClk             : in    std_logic;
        iReset           : in    std_logic;
        iWrite           : in    std_logic;
        iRead            : in    std_logic;
        iAddress0         : in    std_logic_vector(31 downto 0);
        iAddress1         : in    std_logic_vector(31 downto 0);
        iAddress2         : in    std_logic_vector(31 downto 0);
        iAddress3         : in    std_logic_vector(31 downto 0);
        iData            : in    std_logic_vector(31 downto 0);
        oData            : in    std_logic_vector(31 downto 0)
    );
end EntityName;

architecture behave of EntityName is
begin
end behave;
