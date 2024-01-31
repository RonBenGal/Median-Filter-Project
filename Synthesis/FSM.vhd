library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.img_proc_pack.all;


entity FSM is
	port(
		clk,rst,start	: in std_logic;
		done  		 	: out std_logic;
		push  		 	: out std_logic;
		read_en 		: out std_logic;
		write_en		: out std_logic;
		read_address,write_address : out std_logic_vector(7 downto 0)
		);
end entity FSM;

architecture FSM_arc of FSM is

type state_type is (s0,s1,s2,s3,s4,s5); 
signal state : state_type;
signal wr_cnt, rd_cnt  				: std_logic_vector(7 downto 0);
signal s_read_en,s_write_en			: std_logic;
signal full,rd_cnt_en 				: std_logic;
signal delay_1,delay_2,delay_3		: std_logic;

begin

	process(clk,rst) is
	begin
		if(rst = '1') then
			wr_cnt <= (others => '0');
			rd_cnt <= (others => '0');		
			state <= s0;
		elsif rising_edge(clk) then
		
			delay_1 <= s_write_en;
			delay_2 <= delay_1;
			delay_3 <= delay_2;

			if(delay_3 = '1') then
				wr_cnt <= wr_cnt + 1;
			end if;
			
			if(rd_cnt_en = '1') then
				rd_cnt <= rd_cnt + 1;
			end if;
				
			if(wr_cnt = x"FF") then
				full <= '1';
			else
				full <= '0';
			end if;		

			case state is
				when s0 => 	if(start = '1') then
							state <= s1;
							end if;
				when s1 => 	state <= s2;
				when s2 => 	state <= s3;
				when s3 => 	if(full = '1') then 
							state <= s4;
							end if;
				when s4 =>	state <= s5;
				when s5 =>	NULL;
			end case;
		end if;
	end process;

	process(state) is
	begin
		case state is
			when s0 =>		push 			<= '0';
							rd_cnt_en 		<= '0';
							s_read_en		<= '0';
							s_write_en		<= '0';
							done			<= '0';
							
			when s1 =>		push 			<= '1';
							rd_cnt_en 		<= '0';
							s_read_en		<= '1';
							s_write_en		<= '0';
							done			<= '0';
							
			when s2 => 		push 			<= '1';
							rd_cnt_en 		<= '1';
							s_read_en		<= '1';
							s_write_en		<= '0';
							done			<= '0';
							
			when s3 =>		push 			<= '1';
							rd_cnt_en 		<= '1';
				            s_read_en		<= '1';
							s_write_en		<= '1';
							done			<= '0';
							
			when s4 =>		push 			<= '1';
				            rd_cnt_en 		<= '0';
				            s_read_en		<= '1';
				            s_write_en		<= '1';
							done			<= '0';
				
			when s5 =>		push 			<= '0';	
				            rd_cnt_en 		<= '0';		
				            s_read_en		<= '0';	
				            s_write_en		<= '0';
							done			<= '1';
		end case;
	end process;
	
read_address <= rd_cnt;
write_address <= wr_cnt;
write_en <= delay_3;
read_en <= s_read_en;

end architecture FSM_arc;











	