library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity instruction_memory is
    generic (imem_size : integer := 1024);
	port(
    
	clock : in std_logic;
	imem_address : in std_logic_vector(31 downto 0);
	imem_data_out : out std_logic_vector(31 downto 0);
	imem_req_in   : in std_logic;
	imem_ack_out  : out std_logic;
	axi_write_en  : in std_logic;
	axi_instructions_in : in std_logic_vector(31 downto 0)
	);
	
end entity instruction_memory;

architecture behavioral of instruction_memory is 


type instructions is array(0 to imem_size) of std_logic_vector(31 downto 0);
signal imem_memory : instructions;

signal imem_ack_out_s :   std_logic;
signal imem_address_s : std_logic_vector(31 downto 0);
begin

 imem_ack_out <=  imem_ack_out_s;
 imem_address_s <= "00" & imem_address(31 downto 2);
	--! Instruction memory read  and write axi .
	imem_read_write: process(clock)
	begin
		if rising_edge(clock) then
			if imem_req_in = '1' or axi_write_en = '1' then  --reduce switching activity when not used 
				if axi_write_en = '1' then
					imem_memory(conv_integer(imem_address_s)) <= axi_instructions_in;
				end if;
				imem_data_out <= imem_memory(conv_integer(imem_address_s));
			end if;
		end if;
		
	end process imem_read_write;
	
	imem_ack_proc: process(clock)
	begin
	   if rising_edge(clock) then 
	       if imem_req_in = '1' then     
	           imem_ack_out_s <= '1';
            else 
               imem_ack_out_s <= '0';
            end if;	      
	    end if;
	end process;


end  behavioral;
