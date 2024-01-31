library ieee;
use ieee.std_logic_1164.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity rom is
	generic (mif_file : string);
	port
	(
		address		: in std_logic_vector (7 downto 0);
		clock		: in std_logic ;
		rden		: in std_logic ;
		q			: out std_logic_vector (1279 downto 0)
	);
end rom;


architecture syn of rom is

begin

	altsyncram_component : altsyncram
	generic map (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => mif_file,
		intended_device_family => "CYCLONE IV E",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "ALTSYNCRAM",
		numwords_a => 256,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		widthad_a => 8,
		width_a => 1280,
		width_byteena_a => 1
	)
	port map (
		address_a => address,
		clock0 => clock,
		rden_a => rden,
		q_a => q
	);



end syn;
