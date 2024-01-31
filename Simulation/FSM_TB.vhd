library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.img_proc_pack.all;

entity FSM_TB is
end entity FSM_TB;

architecture FSM_TB_arch of FSM_TB is

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
			next_row : out std_logic_vector(1289 downto 0);
			curr_row : out std_logic_vector(1289 downto 0)
			);
	end component buff;
	
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
	
	component FSM is
		port(
			clk   				: in std_logic;
			rst					: in std_logic;
			start 				: in std_logic;
			push  				: out std_logic;
			done 				: out std_logic;
			read_en				: out std_logic;
			write_en			: out std_logic;
			read_address		: out std_logic_vector(7 downto 0);
			write_address		: out std_logic_vector(7 downto 0)
			);
	end component FSM;
			
	signal clk 		  : std_logic := '0';
	signal rst 		  : std_logic := '1';
	signal start 	  : std_logic := '0';
	signal done 	  : std_logic;
	signal curr_row   : std_logic_vector(1289 downto 0);
	signal prev_row   : std_logic_vector(1289 downto 0);
	signal out_sig 	  : std_logic_vector (1279 downto 0);
					  
	signal s_read_address	 		: std_logic_vector(7 downto 0);
	signal s_write_address	  		: std_logic_vector(7 downto 0);
	signal s_read_en 	  	: std_logic;
	signal s_write_en 	 	: std_logic;
	signal s_push	 	 	: std_logic;
	signal rom_to_buff 		: std_logic_vector(1279 downto 0);
	signal buff_to_ram 		: std_logic_vector(1289 downto 0);
	

begin

	U1_RoM : rom
		generic map(mif_file => Test_File)
		port map(
				address => s_read_address,
				clock 	=> clk,
				rden 	=> s_read_en,
				q 		=> rom_to_buff
				);
	
	U2_Buffer : buff 
		port map(
				clk => clk,
				rst => rst,
				push => s_push,
				new_row => rom_to_buff,
				prev_row => prev_row,
				curr_row => curr_row,
				next_row => buff_to_ram
				);
				
	U3_RaM : ram
		port map(
				address => s_write_address,
				clock => clk,
				data => buff_to_ram(1284 downto 5),
				wren => s_write_en,
				q => out_sig
				);
				
	U4_FSM : FSM
		port map(
				clk => clk,
				rst => rst,
				start => start,
				push => s_push,
				done => done,
				read_en => s_read_en,	
				write_en => s_write_en,		
				read_address => s_read_address,
				write_address => s_write_address
				);
				
				
	clk <= not(clk) after 5 ns;
	rst <= '0' after 20 ns;
	
	process is
	begin
		wait for 38 ns;
		start <= '1';
		wait until rising_edge(clk);
		start <= '0';
		wait until rising_edge(clk);
		wait;
	end process;

end architecture FSM_TB_arch;