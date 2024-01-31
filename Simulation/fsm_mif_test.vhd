library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;
-------------------------------------------------------------------------------
entity mif_test is
   generic
      (pic_width      : integer := 256;
       pic_height     : integer := 256;
       file_path      : string  := "C:\intelFPGA_lite\19.1\Project\";
       mif_file_path  : string  := "C:\intelFPGA_lite\19.1\Project\";
       mif_file_name  : string  := "FSM_TEST.mif";
       color_depth    : integer :=5
       );
end entity mif_test;
-------------------------------------------------------------------------------
architecture arc_mif_test of mif_test is
begin
   process is
      file mif           : text;
      variable l         : line;
      variable f_status  : file_open_status;
   begin
      file_open(f_status, mif, mif_file_path & mif_file_name, write_mode);
      assert (f_status = open_ok)
         report "file creating failure" & time'image(now)
         severity failure;
      assert (f_status /= open_ok)
         report "file mif is opened"
         severity note;
      write(l, string'("WIDTH=") & integer'image(color_depth*pic_width) & string'(";"));
      writeline(mif, l);
      write(l, string'("DEPTH=") & integer'image(pic_height) & string'(";"));
      writeline(mif, l);
      write(l, string'("ADDRESS_RADIX = BIN;"));
      writeline(mif, l);
      write(l, string'("DATA_RADIX = BIN;"));
      writeline(mif, l);
      write(l, string'("CONTENT"));
      writeline(mif, l);
      write(l, string'("BEGIN"));
      writeline(mif, l);
      l1 : for i in 0 to (pic_height-1) loop
         write(l, conv_std_logic_vector(i,8));
         write(l, string'(" : "));
         write(l, conv_std_logic_vector(i,pic_width*color_depth)); 
         write(l, string'(";"));
         writeline(mif, l);
      end loop l1;
      write(l, string'("END;"));
      writeline(mif, l);
      file_close(mif);
      assert (false)
         report "Destination files at " & mif_file_path & " are created"
         severity note;
      wait;
   end process;
end architecture arc_mif_test;