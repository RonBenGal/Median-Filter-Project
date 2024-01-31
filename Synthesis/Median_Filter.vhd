library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.img_proc_pack.all;

entity Median_Filter is
	port(
		prev_row : in std_logic_vector(1289 downto 0);
		curr_row : in std_logic_vector(1289 downto 0);
		next_row : in std_logic_vector(1289 downto 0);
		proc_row : out std_logic_vector(1279 downto 0)
		);
end entity Median_Filter;

architecture Median_Filter of Median_Filter is
begin
	proc_row <= full_median(prev_row ,curr_row ,next_row);
end architecture Median_Filter;