library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package img_proc_pack is


type color_file is array (0 to 2) of string(1 to 5);
constant color : color_file;
constant Test_File : string;
-- median - calculates the median of 3 elements of 5bit
-- full_median - by using median function calculates std_logic_vector of

function median (row : std_logic_vector; p : integer) return std_logic_vector;
function full_median ( prev_row : std_logic_vector ; curr_row : std_logic_vector; next_row : std_logic_vector) 
																					return std_logic_vector;

end package img_proc_pack;

package body img_proc_pack is

constant color : color_file := ("r.mif" , "g.mif" , "b.mif");
constant Test_File : string := "FSM_TEST.mif";

function median (row : std_logic_vector ; p : integer) return std_logic_vector is
variable median_color : std_logic_vector(4 downto 0);
variable a,b,c : std_logic_vector(4 downto 0); 
	begin
			a := row(1289-5*p downto 1285-5*p);
			b := row(1284-5*p downto 1280-5*p);
			c := row(1279-5*p downto 1275-5*p);
			if((a >= b and a <= c) or (a >= c and a <= b)) then
				median_color := a;
			elsif((b >= a and b <= c) or (b >= c and b <= a)) then
				median_color := b;
			else
				median_color := c;
--			elsif((c >= a and c <= b) or (c >= b and c <= a)) then
--				median_color := c;
--			else
--				median_color := a;
			end if;	
	return median_color;
end function median;	


function full_median ( prev_row : std_logic_vector ; curr_row : std_logic_vector; next_row : std_logic_vector) 
					return std_logic_vector is				
variable proc_row : std_logic_vector(1279 downto 0);
variable a,b,c : std_logic_vector(4 downto 0);
begin	
	 for i in 0 to 255 loop	
		a := median(prev_row , i);
		b := median(curr_row , i);
		c := median(next_row , i);
		if((a >= b and a <= c) or (a >= c and a <= b)) then
			proc_row(1279-5*i downto 1275-5*i) := a;
		elsif((b >= a and b <= c) or (b >= c and b <= a)) then
			proc_row(1279-5*i downto 1275-5*i) := b;
		else
			proc_row(1279-5*i downto 1275-5*i) := c;
		--elsif((c >= a and c <= b) or (c >= b and c <= a)) then
		--	proc_row(1279-5*i downto 1275-5*i) := c;
		--else
		--	proc_row(1279-5*i downto 1275-5*i) := a;
		end if;
	end loop;			
return proc_row;
end function full_median;	 
	
end package body img_proc_pack;	
	
	
	
	
	
	
	
	