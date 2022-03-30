-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.pp_types.all;
use work.pp_utilities.all;

--! @brief 32-bit RISC-V register file.
entity pp_register_file is
    generic ( dmem_size : integer := 4096);
	port(
		clk    : in std_logic;

		-- Read port 1:
		rs1_addr : in  register_address;
		rs1_data : out std_logic_vector(31 downto 0);

		-- Read port 2:
		rs2_addr : in  register_address;
		rs2_data : out std_logic_vector(31 downto 0);

		-- Write port:
		rd_addr  : in register_address;
		rd_data  : in std_logic_vector(31 downto 0);
		rd_write : in std_logic;
		sp_init  : in std_logic
	);
end entity pp_register_file;

architecture behaviour of pp_register_file is

	--! Register array type.
	type regfile_array is array(0 to 31) of std_logic_vector(31 downto 0);

	
begin
    

	regfile: process(clk)
		variable registers : regfile_array ;
		
		begin
	  
		
		if rising_edge(clk) then
		     if sp_init = '1' then --stack pointer initialization 
		          for i in 0 to 31 loop
                       if i = 2 then 
                            registers(i) := std_logic_vector(to_unsigned(dmem_size*4, 32));
                        else 
                            registers(i) := x"00000000";
                        end if;
                   end loop;
		             
		     else              -- to sundew me to last data in pou einai pada palmos
				if rd_write = '1' and rd_addr /= b"00000" then
					registers(to_integer(unsigned(rd_addr))) := rd_data;
					   if rd_addr = rs1_addr then
					       rs1_data <= rd_data;
					   end if;
					   
					   if rd_addr = rs2_addr then
					       rs2_data <= rd_data;
					   end if;
				
                 end if;
				rs1_data <= registers(to_integer(unsigned(rs1_addr)));
				rs2_data <= registers(to_integer(unsigned(rs2_addr)));	    
		      end if;
		end if;
		
	end process regfile;

end architecture behaviour;
