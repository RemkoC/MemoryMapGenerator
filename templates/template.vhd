library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity #MM PUTS name MM#ApbIf is
    port (
        iClk             : in    std_logic;
        iReset           : in    std_logic;
        
#MM LOOP type field MM#
        #MM PUTS DIRECTION %.1s MM##MM PUTS name %-15s MM# : #MM PUTS DIRECTION %-5s MM# #MM PUTS VHDLTYPE MM#;
#MM ENDLOOP MM#
        
        iWrite           : in    std_logic;
        iRead            : in    std_logic;
        iAddress         : in    std_logic_vector(31 downto 0);
        iData            : in    std_logic_vector(31 downto 0);
        oData            : in    std_logic_vector(31 downto 0)
    );
end #MM PUTS name MM#ApbIf ;

architecture behave of #MM PUTS name MM#ApbIf is

#MM LOOP type register MM#
    constant C_ADDR_#MM PUTS name %-32s MM# : integer := x"#MM PUTS offset %08x MM#";
#MM ENDLOOP MM#


#MM LOOP type field MM#
#MM IF DIRECTION "out" MM#
    signal #MM PUTS name %-15s MM# : #MM PUTS VHDLTYPE MM#;
#MM ENDIF MM#
#MM ENDLOOP MM#

begin

#MM LOOP type field MM#
#MM IF DIRECTION "out" MM#
    o#MM PUTS name %-15s MM# := #MM PUTS name %s MM#;
#MM ENDIF MM#
#MM ENDLOOP MM#

    write_data: process (iClk, iReset)
    begin
        if (iClk'event and iClk = '1')
            if (iReset = '1') then
#MM LOOP type field MM#
                #MM PUTS DIRECTION MM##MM PUTS name %-14s  MM# <= (OTHERS => '0');
#MM ENDLOOP MM#
                
            else
                if (iWrite = '1') then
                    case iAddress is
#MM LOOP type register MM#
                        when C_ADDR_#MM PUTS name MM# =>
#MM LOOP type field MM#
#MM IF access "RW" MM#
                            #MM PUTS name %-14s  MM# <= oData#MM PUTS VHDLRANGE MM#;
#MM ENDIF MM#
#MM ENDLOOP MM#
                            
#MM ENDLOOP MM#
                        when others =>
                            NULL;
                            
                    end case;
                end if;
            end if;
        end if;
    end process;

    read_data: process (iClk, iReset)
    begin
        if (iClk'event and iClk = '1')
            if (iReset = '1') then
                oData <= (OTHERS => '0');
                
            else
                if (iRead = '1') then
                    case iAddress is
#MM LOOP type register MM#
                        when C_ADDR_#MM PUTS name MM# =>
#MM LOOP type field MM#
#MM IF access "R" MM#
                            oData#MM PUTS VHDLRANGE %-15s MM# <= #MM PUTS DIRECTION %.1s MM##MM PUTS name MM#;
#MM ENDIF MM#
#MM IF access "RW" MM#
                            oData#MM PUTS VHDLRANGE %-15s MM# <= #MM PUTS name MM#;
#MM ENDIF MM#
#MM ENDLOOP MM#
                            
#MM ENDLOOP MM#
                        when others =>
                            NULL;
                            
                    end case;
                end if;
            end if;
        end if;
    end process;
end behave;
