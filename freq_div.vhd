library ieee;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;


entity freq_div is 
	generic(
	fac_div : integer := 6); -- Factor divisor de frecuencia

port (
	clk			: in std_logic;    -- DE1 clock (50 MHz)
	stop        : in std_logic ;
	clk_out 		: out std_logic
);

end freq_div;

architecture funcional of freq_div is 


signal cont : integer range 0 to fac_div := 0;  	   


begin 
	
	process(clk, stop)
	
	begin 
	
	if stop = '0' then
	   clk_out <='1';
	   cont <= 0;
	else
            if clk'event and clk='0' then																	--Este divisor cuenta el factor elegido para [0-f/2] en valor '1' y 
            
                if cont >= fac_div/2 and cont < fac_div-1 then
                
                    clk_out <='1';
                    cont <= cont+1;
        
                elsif cont = fac_div-1 then 
                
                    cont <=0 ;
                    clk_out <='1';
                        
                else 
                
                    cont <= cont+1;
                    clk_out <='0';
                    
                end if;
			
		
	           end if;
	end if;
	end process;
	
end funcional;