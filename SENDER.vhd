----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.02.2024 12:54:27
-- Design Name: 
-- Module Name: SENDER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SENDER is
    Port ( FRAME : in std_logic_vector (39 downto 0);
           clk : in std_logic; 
           flag_in: in std_logic;
           flag_clk : out std_logic ; 
           flag_out: out std_logic ;
           DATA_OUT : out STD_LOGIC
           );
end SENDER;

architecture Behavioral of SENDER is
signal position : integer range 0 to 40 := 40 ;
signal counter: integer range 0 to 8 := 0 ;
signal signal_out : std_logic := '0';
type state_type is (S0, S1);
signal current_state : state_type := S0;
begin
process (flag_in, clk, FRAME)
    begin
    signal_out <= '0';
    flag_out <= signal_out;       
        if flag_in = '1' then             
            if clk'event and clk='0' then                
                
                case current_state is
                    when S0 =>
                        
                        if counter > 7 then
                            
                            current_state <= S1;
                            counter <= 0;
                            flag_clk <= '1';
                            DATA_OUT <= '1';
                        else  
                            DATA_OUT <= FRAME(Position-1);
                            position <= position - 1;
                            signal_out <= '0'; 
                            counter <= counter + 1;
                            flag_clk <= '0';
                        
                        end if;
                    
                    when S1 =>
                        if position <= 2 then
                           signal_out <= '1';
                           DATA_OUT <= '1';  
                           position <= 40;
                           flag_clk <= '1';
                           current_state <= S0; 
                        else    
                            if counter > 7 then
                                
                                current_state <= S0;
                                counter <= 0;
                                flag_clk <= '1';
                            else 
                                
                                DATA_OUT <= '1';   
                                counter <= counter + 1;
                                flag_clk <= '1';
                            end if;
                        
                        
                        end if;
             
              end case;
          end if;
       end if;
end process;
end Behavioral;
