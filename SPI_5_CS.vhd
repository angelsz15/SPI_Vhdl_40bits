----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2024 11:13:46
-- Design Name: 
-- Module Name: SPI_5_CS - Behavioral
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

entity SPI_5_CS is
 Port (    
           cs_mulplex_selector : in std_logic_vector (2 downto 0) ; -- This entrance select the chip select
           stop_flag : in std_logic ; -- This flag turn off the state machine for the SPI when the controller doesn't have more frames to send
           enable_flag : out std_logic ; -- This flag send a pulse when state machine finish a cicle of sending (the cicle of sendind is definided in README.txt)  
           FRAME_IN: in std_logic_vector (39 downto 0); -- This entrance set the full frame that is going to send for the drivers.
           start_flag : in std_logic;  -- This flag turn on the state machine for the SPI, the controller must send a pulse to the FPGA when it want to start the SPI communication to the drivers
           clk_FPGA : in std_logic;                        
           cs_0: out std_logic;
           cs_1: out std_logic; 
           cs_2: out std_logic;
           cs_3: out std_logic; 
           cs_4: out std_logic;  
           clk_SPI : out std_logic ;                           
           MOSI_TOP : out STD_LOGIC;
           MISO_TOP : in std_logic );
end SPI_5_CS;

architecture Behavioral of SPI_5_CS is


signal  cs_internal : std_logic ;


component STATE_MACHINE is
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
end component STATE_MACHINE;



begin

SPI_CS1 : STATE_MACHINE 
    port map (    
           turn_on => start_flag,  
           clk_top => clk_FPGA,                        
           cs => cs_internal, 
           clk_out => clk_SPI ,                           
           signal_MOSI => MOSI_TOP, 
           flag_end_send => stop_flag,
           flag_new_frame => enable_flag,
           FRAME_DATA_MOSI => FRAME_IN,           
           signal_MISO => MISO_TOP        
            );

process (cs_mulplex_selector)

begin

case cs_mulplex_selector is
        when "000" => 
            cs_0 <= cs_internal;
            cs_1 <= '1';
            cs_2 <= '1';
            cs_3 <= '1';
            cs_4 <= '1';
            
        
        when "001" => 
            cs_0 <= '1';
            cs_1 <= cs_internal;
            cs_2 <= '1';
            cs_3 <= '1';
            cs_4 <= '1';
        
        when "010" => 
            cs_0 <= '1';
            cs_1 <= '1';
            cs_2 <= cs_internal;
            cs_3 <= '1';
            cs_4 <= '1';
   
   
        when "011" =>           
            cs_0 <= '1';
            cs_1 <= '1';
            cs_2 <= '1';
            cs_3 <= cs_internal;
            cs_4 <= '1';

        when "100" => 
            cs_0 <= '1';
            cs_1 <= '1';
            cs_2 <= '1';
            cs_3 <= '1';
            cs_4 <= cs_internal;
        when others => 
            cs_0 <= '1';
            cs_1 <= '1';
            cs_2 <= '1';
            cs_3 <= '1';
            cs_4 <= '1';
    end case;

end process;


end Behavioral;
