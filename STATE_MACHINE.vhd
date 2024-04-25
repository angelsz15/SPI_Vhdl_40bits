----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2024 12:22:32
-- Design Name: 
-- Module Name: STATE_MACHINE - Behavioral
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

entity STATE_MACHINE is
     generic ( factor_clk : INTEGER := 6);
     Port (
           turn_on : in std_logic;  
           clk_top : in std_logic;                        
           cs: inout std_logic;  
           clk_out : out std_logic ;                           
           signal_MOSI : out STD_LOGIC;
           flag_end_send : in std_logic ;
           flag_new_frame : out std_logic ;
           FRAME_DATA_MOSI: in std_logic_vector (39 downto 0);           
           signal_MISO : in std_logic );
end STATE_MACHINE;

architecture Behavioral of STATE_MACHINE is
    signal get_frame: std_logic :='0';
    signal flag_C, flag_on_off: std_logic := '0' ;
    signal clk_div: std_logic ;
    signal flag_key : std_logic := '0' ;
    signal counter : integer range 0 to 100*factor_clk := 0 ;
    signal FRAME_DATA_MISO : std_logic_vector (39 downto 0);
    type state_type is (S_init,S0, S1,S_pause);
    signal current_state : state_type := S_init;
    
    
    component SENDER is
        Port (
            FRAME : in std_logic_vector (39 downto 0);
            clk : in std_logic;                       
            flag_in: in std_logic;                    
            flag_out: out std_logic ;
            flag_clk : out std_logic ;                 
            DATA_OUT : out STD_LOGIC                  
        );
    end component SENDER;
        
    component  freq_div is
          Port ( 
          clk			: in std_logic;
          stop          : in std_logic;   
	      clk_out 		: out std_logic 
           );
    end component freq_div;
    
    
begin
    
    
    MOSI_prcss : SENDER 
    port map (FRAME => FRAME_DATA_MOSI,
            clk => clk_div,
            flag_in => flag_key,
            flag_clk => flag_C,
            flag_out => get_frame,
            DATA_OUT => signal_MOSI);
            
    Div_freq : freq_div
    port map (
            clk => clk_top,
            stop => flag_key,
            clk_out => clk_div);                
    
    
    process (clk_top, cs, current_state, flag_C, get_frame)
    
    
    begin
        
       flag_new_frame <= get_frame;
       
       clk_out <= (clk_div or flag_C);
     
     if turn_on = '1' then
        flag_on_off <= '1' ;
     end if;
  
       if  clk_top'event and clk_top='0' then         
                case current_state is
                    
                    when S_init =>
                        cs <='1';                       
                        flag_key <= '0';
                        
                        if flag_on_off = '1' then
                            counter <= counter+1;
                            if counter > (100*factor_clk-factor_clk) then
                                
                                cs <='0';
                                if counter > (100*factor_clk-1) then
                                    current_state <=S0;
                                    cs <='0';
                                end if;
                            end if;
                        end if;
                    
                    when S0 =>
                        cs <='0';                                               
                        flag_key <= '1';
                        if  get_frame ='1'  then
                            current_state <=S_pause;
                            counter<= 0;
                            flag_key <= '0';                    
                        end if;
                    
                    when S_pause =>                      
                        cs <='1';
                        flag_key <= '0';
                        counter<= counter+1;
                        if counter > (10*factor_clk-factor_clk) then
                            cs <='0';
                            if counter > (10*factor_clk-1) then
                                current_state <=S1;                           
                                counter<= 0;
                                cs <='0';
                            end if;
                        end if;
                        
                    when S1 =>
                        cs <='0';                                                                      
                        flag_key <= '1';  
                        if  get_frame ='1'  then
                            current_state <=S_init;
                            counter<= 0;
                            if flag_end_send = '1' then
                               flag_on_off <= '0' ;
                               flag_key <= '0';
                            end if;                 
                        end if;
                     
                end case;
       end if;  
    end process;

end Behavioral;
