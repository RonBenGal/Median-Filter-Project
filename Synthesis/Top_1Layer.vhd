library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.img_proc_pack.all;

entity Top_1Layer is
generic(color : string);
port(
	clk,rst 				: in std_logic;
	read_en					: in std_logic;
	write_en				: in std_logic;
	push					: in std_logic;
	read_address			: in std_logic_vector(7 downto 0);
	write_address			: in std_logic_vector(7 downto 0)
	);

end entity Top_1Layer;

architecture Top_1Layer_arch of Top_1Layer is

	component rom is
		generic ( mif_file : string);
		port
			(
				address	: in std_logic_vector (7 downto 0);
				clock	: in std_logic;
				rden	: in std_logic ;
				q		: out std_logic_vector (1279 downto 0)
			);
	end component rom;
	
	component buff is
		port(
			clk,rst	 : in std_logic;
			push     : in std_logic;
			new_row  : in std_logic_vector(1279 downto 0);
			prev_row : out std_logic_vector(1289 downto 0);
			curr_row : out std_logic_vector(1289 downto 0);
			next_row : out std_logic_vector(1289 downto 0)
			);
	end component buff;
	
	component Median_Filter is
		port
			(
			prev_row : in std_logic_vector(1289 downto 0);
			curr_row : in std_logic_vector(1289 downto 0);
			next_row : in std_logic_vector(1289 downto 0);
	        proc_row : out std_logic_vector(1279 downto 0)
			);
	end component Median_Filter;
	
	component ram is
		port
		(
			address	: in std_logic_vector (7 downto 0);
			clock	: in std_logic;
			data	: in std_logic_vector (1279 downto 0);
			wren	: in std_logic;
			q		: out std_logic_vector (1279 downto 0)
		);
	end component ram;
	
	signal rom_to_buff 		: std_logic_vector(1279 downto 0);
	signal s_prev_row		: std_logic_vector(1289 downto 0);
	signal s_curr_row		: std_logic_vector(1289 downto 0);
	signal s_next_row		: std_logic_vector(1289 downto 0);
	signal filter_out  		: std_logic_vector(1279 downto 0);
	signal out_sig			: std_logic_vector(1279 downto 0);
		        
begin

	U1_RoM : rom
		generic map(mif_file => color)
		port map(
				address	=> read_address,
				clock   => clk,
				rden	=> read_en,	
				q		=> rom_to_buff
				);
				
	U2_Buffer : buff
		port map(
				clk		 => clk,
				rst		 => rst,
		        push     => push,
		        new_row  => rom_to_buff,
		        prev_row => s_prev_row,
				curr_row => s_curr_row,
		        next_row => s_next_row
				);
				
	U3_Filter : Median_Filter
		port map(
				prev_row => s_prev_row,
		        curr_row => s_curr_row,
				next_row => s_next_row,
		        proc_row => filter_out
				);
				
	U4_RaM	: ram
		port map(
				address	=> write_address,
				clock	=> clk,
				data	=> filter_out,
                wren	=> write_en,
                q       => out_sig
				);
	

end architecture Top_1Layer_arch;