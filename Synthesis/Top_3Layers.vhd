library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.img_proc_pack.all;

entity Top_3Layers is
	port(
		clk   : in std_logic;
		rst	  : in std_logic;
		start : in std_logic;
		done  : out std_logic
		);
		
	attribute altera_chip_pin_lc : string;
   attribute altera_chip_pin_lc of clk  : signal is "Y2";
   attribute altera_chip_pin_lc of rst  : signal is "AB28";
	attribute altera_chip_pin_lc of start: signal is "AC28";
   attribute altera_chip_pin_lc of done : signal is "E21";
	 
end entity Top_3Layers;

architecture Top_3Layers_Architecture of Top_3Layers is

	component Top_1Layer is
	generic(color : string);
	port(
		clk,rst 				: in std_logic;
		read_en					: in std_logic;
		write_en				: in std_logic;
		push					: in std_logic;
		read_address			: in std_logic_vector(7 downto 0);
		write_address			: in std_logic_vector(7 downto 0)
	);
	end component Top_1Layer;
	
	component FSM is
	port(
		clk,rst,start	: in std_logic;
		done  		 	: out std_logic;
		push  		 	: out std_logic;
		read_en 		: out std_logic;
		write_en		: out std_logic;
		read_address,write_address : out std_logic_vector(7 downto 0)
		);
	end component FSM;
	
	signal read_enable 			: std_logic;
	signal write_enable 		: std_logic;
	signal push_signal			: std_logic;
	signal read_address 		: std_logic_vector(7 downto 0);
	signal write_address 		: std_logic_vector(7 downto 0);
	
begin	

	GEN_COLOR: for i in 0 to 2 generate
	ColorX : Top_1Layer 
		generic map(color => color(i))
		port map(
		clk => clk,
		rst => rst,			
		read_en	=> read_enable,			
		write_en => write_enable,				
		push => push_signal, 					
		read_address => read_address,			
		write_address => write_address		
		);	
	end generate GEN_COLOR;

	GEN_FSM : FSM
	port map(
	clk => clk,
	rst => rst,
	start => start,	
	done => done,  		 	
	push => push_signal, 		 	
	read_en => read_enable,		
	write_en => write_enable,		
	read_address => read_address,
	write_address => write_address	
	);
	
end architecture Top_3Layers_Architecture;