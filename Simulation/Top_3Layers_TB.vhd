library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.img_proc_pack.all;

entity Top_3Layers_tb is
end entity Top_3Layers_tb;

architecture Top_3Layers_tb_Architecture of Top_3Layers_tb is

	component Top_3Layers is
		port(
			clk   : in std_logic;
		    rst	  : in std_logic;
		    start : in std_logic;
		    done  : out std_logic
            );
	end component Top_3Layers;
	
	signal clk   : std_logic := '0';
	signal rst   : std_logic := '1';
	signal start : std_logic := '0';
	signal done  : std_logic;
	
begin
	
	gen_project : Top_3Layers
		port map(
				clk   => clk,
				rst	  => rst,
				start => start,
				done  => done
				);
				
	clk <= not(clk) after 5 ns;
	rst <= '0' after 20 ns;
	
	process is
		begin
		wait for 30 ns;
		wait until rising_edge(clk);
		start <= '1';
		wait until rising_edge(clk);
		start <= '0';
		wait until rising_edge(clk);	
		wait;
	end process;

end architecture Top_3Layers_tb_Architecture;