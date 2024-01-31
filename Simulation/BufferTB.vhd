library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity BufferTB is
end entity BufferTB;

architecture BufferTB_arch of BufferTB is

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

	component rom is
		generic (mif_file : string);
		port
		(
			address		: in std_logic_vector (7 downto 0);
			clock		: in std_logic;
			q		: out std_logic_vector (1279 downto 0)
		);
	end component rom;

	signal	clk 		: std_logic := '1';
	signal  rst 		: std_logic := '1';
	signal	push 		: std_logic := '0';
	signal  new_row  	: std_logic_vector(1279 downto 0);
	signal  prev_row  	: std_logic_vector(1289 downto 0);
	signal  next_row  	: std_logic_vector(1289 downto 0);
	signal  curr_row  	: std_logic_vector(1289 downto 0);
	
	signal address 		: std_logic_vector (7 downto 0) := (others => '0');

	
begin 

	U1 : rom
		generic map(mif_file => "r.mif")
		port map(
				clock => clk,
				address => address,
				q		=> new_row
				);
				

	U2 : buff	
		port map(
				clk => clk,
				rst => rst,
				push => push,
				new_row => new_row,
				prev_row => prev_row,
				next_row => next_row,
				curr_row => curr_row
				);
				

	clk <= not(clk) after 5 ns;	
	rst <= '0' after 5 ns;
	
	process is
	begin
		wait for 20 ns;
		wait until rising_edge(clk);
			push <= '1';
		wait until rising_edge(clk);
			push <= '0';
		wait until rising_edge(clk);	
			for i in 0 to 100 loop
				address <= address + 1;
				push <= '1';
				wait until rising_edge(clk);
				push <= '0';
				wait until rising_edge(clk);
			end loop;		
	wait;
	end process; 
end architecture BufferTB_arch;	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
