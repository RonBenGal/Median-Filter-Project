library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.img_proc_pack.all;

entity buff is
	port(
		clk,rst	 : in std_logic;
		push     : in std_logic;
		new_row  : in std_logic_vector(1279 downto 0);
		prev_row : out std_logic_vector(1289 downto 0);
		curr_row : out std_logic_vector(1289 downto 0);
		next_row : out std_logic_vector(1289 downto 0)
		);
end entity buff;

architecture buff_arc of buff is

signal prev_s : std_logic_vector(1289 downto 0);
signal curr_s : std_logic_vector(1289 downto 0);
signal next_s : std_logic_vector(1289 downto 0);

begin

	prev_row <= prev_s;
	curr_row <= curr_s;
	next_row <= next_s;
	
	process (clk,rst) is
	begin
		if(rst = '1') then
			prev_s <= (others => '1');
			curr_s <= (others => '1');
			next_s <= (others => '1');
		elsif rising_edge(clk) then
			if(push = '1') then
				prev_s <= new_row(1279 downto 1275) & new_row & new_row(4 downto 0);
				curr_s <= prev_s;
				next_s <= curr_s;
			end if;
		end if;
	end process;
end architecture buff_arc;