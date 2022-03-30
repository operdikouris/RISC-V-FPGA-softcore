library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;




entity data_memory is
generic (dmem_size : integer := 4096); --*4 for bytes 
port (
	clk : in std_logic;
	dmem_address : in std_logic_vector(31 downto 0);
	dmem_data_in : in std_logic_vector(31 downto 0);
	dmem_data_out : out std_logic_vector(31 downto 0);
	dmem_data_size : in std_logic_vector(1 downto 0);
	dmem_read_req : in std_logic;
	dmem_read_ack  : out std_logic;
	dmem_write_req : in std_logic;
	dmem_write_ack : out std_logic
	);
end entity data_memory;

architecture behavioral of data_memory is

signal size : std_logic_vector(1 downto 0); -- egw to pros8esa gia delay sto dmem_data_size
signal rdata : std_logic_vector(31 downto 0);
signal dmem_write_ack_s ,dmem_read_ack_s : std_logic ;
signal dmem_address_s : std_logic_vector(31 downto 0);

 type dmem_file_t is array (0 to dmem_size) of std_logic_vector(7 downto 0);
 signal dmem_file_ll : dmem_file_t ;
 signal dmem_file_lh : dmem_file_t ;
 signal dmem_file_hl : dmem_file_t ;
 signal dmem_file_hh : dmem_file_t ;
 --attribute block for block ram distributed for distributed ram
attribute ram_style : string;

attribute ram_style of dmem_file_ll  : signal is "block";
attribute ram_style of dmem_file_lh  : signal is "block";
attribute ram_style of dmem_file_hl  : signal is "block";
attribute ram_style of dmem_file_hh  : signal is "block";
--attribute ram_style of data_memory  : entity is "distributed";
begin

    dmem_write_ack <= dmem_write_ack_s;
    dmem_read_ack <= dmem_read_ack_s;
	   -- output gate --
	--dmem_data_out <= rdata when (dmem_read_req = '1') else (others => '0');

----==================== dikh m pros8hkh
--size_delay : process(clk)
--begin
-- if rising_edge(clk) then
--    size <= dmem_data_size;
-- end if;
--end process;

----dmem_data_out <= (rdata(31 downto 4) & "0000") when size = "11" else rdata; --4 bit trunc
--dmem_data_out <= (rdata(31 downto 8) & "00000000") when size = "11" else rdata; --8 bit trunc

---====================
 	dmem_data_out <= rdata;
 	dmem_address_s <= "00" & dmem_address(31 downto 2); -- diairw ka8e dieu8unsh me to 4
--
--   dmem_file_access: process(clk)
--   begin
--     if rising_edge(clk) then
--
--       if (dmem_read_req  = '1' or dmem_write_req = '1') then -- reduce switching activity when not accessed
--         -- write --
--         if (dmem_write_req = '1') then
-- 			if (dmem_data_size = "01") then
-- 				dmem_file_ll(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(07 downto 00);
-- 			elsif (dmem_data_size = "10") then
-- 				dmem_file_ll(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(07 downto 00);
-- 				dmem_file_lh(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(15 downto 08);
-- 			elsif (dmem_data_size = "00") then
-- 				dmem_file_ll(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(07 downto 00);
-- 				dmem_file_lh(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(15 downto 08);
-- 				dmem_file_hl(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(23 downto 16);
-- 				dmem_file_hh(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(31 downto 24);
-- 			else
-- 			  	dmem_file_ll(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(07 downto 00);
--
-- 			end if;
--
--         end if;
--         -- read -- ================
-- --
--             rdata(07 downto 00) <= dmem_file_ll(to_integer(unsigned(dmem_address_s)));
--             rdata(15 downto 08) <= dmem_file_lh(to_integer(unsigned(dmem_address_s)));
--             rdata(23 downto 16) <= dmem_file_hl(to_integer(unsigned(dmem_address_s)));
--             rdata(31 downto 24) <= dmem_file_hh(to_integer(unsigned(dmem_address_s)));
--
-- --        =========================
--       end if;
--     end if;
--   end process dmem_file_access;

dem_file_access_ll : process(clk)
begin
  if rising_edge(clk) then
--    if ((dmem_read_req  = '1' or dmem_write_req = '1') and dmem_data_size /= "11") then
    if (dmem_read_req  = '1' or dmem_write_req = '1') then

      if (dmem_write_req = '1') then -- write
          	dmem_file_ll(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(07 downto 00);
      end if;
      --read
      rdata(07 downto 00) <= dmem_file_ll(to_integer(unsigned(dmem_address_s)));
    end if;
  end if;
end process;

dmem_file_access_lh : process(clk)
begin
  if rising_edge(clk) then
    if (dmem_read_req  = '1' or dmem_write_req = '1' ) then
      if (dmem_write_req = '1') then -- write
        if (dmem_data_size = "10" or dmem_data_size = "00") then 
          	 dmem_file_lh(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(15 downto 08);
        end if;
      end if;
      --read
       rdata(15 downto 08) <= dmem_file_lh(to_integer(unsigned(dmem_address_s)));
    end if;
  end if;
end process;

dmem_file_access_hl : process(clk)
begin
  if rising_edge(clk) then
    if (dmem_read_req  = '1' or dmem_write_req = '1' ) then
      if (dmem_write_req = '1') then -- write
        if ( dmem_data_size = "00") then 
          dmem_file_hl(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(23 downto 16);
        end if;
      end if;
      --read
      rdata(23 downto 16) <= dmem_file_hl(to_integer(unsigned(dmem_address_s)));
    end if;
  end if;
end process;

dmem_file_access_hh : process(clk)
begin
  if rising_edge(clk) then
    if (dmem_read_req  = '1' or dmem_write_req = '1' ) then
      if (dmem_write_req = '1') then -- write
        if ( dmem_data_size = "00") then 
          dmem_file_hh(to_integer(unsigned(dmem_address_s))) <= dmem_data_in(31 downto 24);
        end if;
      end if;
      --read
      rdata(31 downto 24) <= dmem_file_hh(to_integer(unsigned(dmem_address_s)));
    end if;
  end if;
end process;





	dmem_write_ack_proc: process(clk)
	begin
	   if rising_edge(clk) then
	       if dmem_write_req = '1' then
	           dmem_write_ack_s <= '1';
	       else
	           dmem_write_ack_s	<= '0';
	       end if;
	   end if;
	end process;



	dmem_read_ack_proc: process(clk)
	begin
	 if rising_edge(clk) then
	   if dmem_read_req = '1' then
	       dmem_read_ack_s <= '1';
	   else
	       dmem_read_ack_s <= '0';
	   end if ;
	 end if;
	end process;


end behavioral;
