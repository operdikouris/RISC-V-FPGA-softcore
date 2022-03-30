library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


 


entity potato_top_level is
generic (imem_size : integer := 512;
--         dmem_size : integer := 1024); --4 kB
           dmem_size : integer := 4096); --16 kB
--            dmem_size : integer := 16384); --64 kB
port (
	clk : in std_logic;
	rstn : in std_logic;
	
	------instruction memory AXI stream ----
	valid_in_instr: in std_logic;
	last_instr_signal: in std_logic;
	instr_data : in std_logic_vector(31 downto 0);
	----------------------------
	----data addresses AXI stream--------
	valid_in_data_adresses : in std_logic;
	last_data_adresses_signal : in std_logic;
	data_addresses : in std_logic_vector(31 downto 0);
	--------------------------------
	----data inputs outputs AXI stream--------
	--INPUTS
	 valid_in_data : in std_logic;
	 last_in_data_signal : in std_logic;
	 data_in :in std_logic_vector(31 downto 0); 
	 --OUTPUTS
	 valid_out_data : out std_logic;
	 last_out_data_signal : out std_logic;
	 data_out : out std_logic_vector(31 downto 0);
	 
	 ready_axis_stream_data_out : in std_logic

	 

	);
end entity potato_top_level;

architecture behavioral  of potato_top_level is 


	component  pp_core is
	   generic (dmem_size : integer := 4096);

		port(
			-- Control inputs:
			clk       : in std_logic; --! Processor clock
			resetn     : in std_logic; --! Reset signal

			timer_clk : in std_logic; --! Clock used for the timer/counter

			-- Instruction memory interface:
			imem_address : out std_logic_vector(31 downto 0); --! Address of the next instruction
			imem_data_in : in  std_logic_vector(31 downto 0); --! Instruction input
			imem_req     : out std_logic;
			imem_ack     : in  std_logic;

			-- Data memory interface:
			dmem_address   : out std_logic_vector(31 downto 0); --! Data address
			dmem_data_in   : in  std_logic_vector(31 downto 0); --! Input from the data memory
			dmem_data_out  : out std_logic_vector(31 downto 0); --! Ouptut to the data memory
			dmem_data_size : out std_logic_vector( 1 downto 0);  --! Size of the data, 1 = 8 bits, 2 = 16 bits, 0 = 32 bits. 
			dmem_read_req  : out std_logic;                      --! Data memory read request
			dmem_read_ack  : in  std_logic;                      --! Data memory read acknowledge
			dmem_write_req : out std_logic;                      --! Data memory write request
			dmem_write_ack : in  std_logic;                      --! Data memory write acknowledge
--            dmem_clk_en : out std_logic; -- 

			-- Tohost/fromhost interface:
			fromhost_data     : in  std_logic_vector(31 downto 0); --! Data from the host/simulator.
			fromhost_write_en : in  std_logic;                     --! Write enable signal from the host/simulator.
			tohost_data       : out std_logic_vector(31 downto 0); --! Data to the host/simulator.
			tohost_write_en   : out std_logic;                     --! Write enable signal to the host/simulator.

			-- External interrupt input:
			irq : in std_logic_vector(7 downto 0); --! IRQ inputs.
			
			last_instruction_address : in std_logic_vector(31 downto 0);
		    end_reached_o : out std_logic;
		    pc_enable : in std_logic;
		    sp_init : in std_logic
		);
	end component;
	
	component data_memory is 
	generic (dmem_size : integer := 4096);

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
	end component;
	
	component instruction_memory is
	
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
	
	end component;

-- Instruction memory interface:
	signal imem_address_s : std_logic_vector(31 downto 0);
	signal imem_data_in_s : std_logic_vector(31 downto 0);
	signal imem_req_s     : std_logic;
	signal imem_ack_s   : std_logic;

	-- Data memory interface:
	signal dmem_address_s   : std_logic_vector(31 downto 0);
	signal dmem_data_in_s   : std_logic_vector(31 downto 0);
	signal dmem_data_out_s  : std_logic_vector(31 downto 0);
	signal dmem_data_size_s : std_logic_vector( 1 downto 0);
	signal dmem_read_req_s, dmem_write_req_s : std_logic;
	signal dmem_read_ack_s, dmem_write_ack_s : std_logic;

	-- Tohost/Fromhost:
	signal tohost_data_s       : std_logic_vector(31 downto 0) := (others => '0') ;
	signal fromhost_data_s     : std_logic_vectoR(31 downto 0) := (others => '0') ; 
	signal tohost_write_en_s   : std_logic := '0';
	signal fromhost_write_en_s : std_logic := '0';

	-- External interrupt input:
	signal irq_s : std_logic_vector(7 downto 0) := (others => '0');
	
	-- axi instrucion memory  signals 
	signal axi_write_en : std_logic;
	signal instr_mem_cnt : std_logic_vector(31 downto 0); -- 
	signal imem_address_arbiter : std_logic_vector(31 downto 0);
	
	--- axi address ram 
	type ram_type is array (0 to 4) of std_logic_vector(31 downto 0);-----------------------------
	signal small_address_ram : ram_type;
	signal addresses_mem_cnt :std_logic_vector(2 downto 0);
	signal addresses_mem_cnt_s :std_logic_vector(2 downto 0);
	
	---axi data ram 
	signal dmem_data_size_arbiter : std_logic_vector(1 downto 0);
	signal dmem_data_in_arbiter   : std_logic_vector(31 downto 0);
	signal dmem_write_req_arbiter : std_logic;
	
	signal dmem_read_req_arbiter : std_logic;
	
	
	signal data_in_mem_cnt : std_logic_vector(31 downto 0); 
	--signal data_in_mem_cnt_s : std_logic_vector(31 downto 0); 
	
	signal data_out_mem_cnt : std_logic_vector(31 downto 0);
	signal pc_enable : std_logic;
	
	
	signal last_instruction_address_s : std_logic_vector(31 downto 0);
	signal end_reached_s : std_logic;
	signal dmem_address_arbiter: std_logic_vector(31 downto 0);
	signal data_out_s  :  std_logic_vector(31 downto 0);
	signal last_out_data_signal_s : std_logic;
	signal valid_out_data_s : std_logic;
	signal valid_out_prior: std_logic;
	

    signal stack_pointer_init : std_logic;
	
	
--	signal clk_en_dmem : std_logic; --  
--	signal clk_gated_mem : std_logic; 
	

begin 


core_unit : pp_core 
    generic map (dmem_size => dmem_size)
	port map(
			clk => clk,
			resetn => rstn,
			timer_clk => clk,
			imem_address => imem_address_s,
			imem_data_in => imem_data_in_s,
			imem_req => imem_req_s,
			imem_ack => imem_ack_s,
			dmem_address => dmem_address_s,
			dmem_data_in => dmem_data_in_s,
			dmem_data_out => dmem_data_out_s,
			dmem_data_size => dmem_data_size_s,
			dmem_read_req => dmem_read_req_s,
			dmem_read_ack => dmem_read_ack_s,
			dmem_write_req => dmem_write_req_s,
			dmem_write_ack => dmem_write_ack_s,
--			dmem_clk_en    => clk_en_dmem, -- 
			tohost_data => tohost_data_s,
			tohost_write_en => tohost_write_en_s,
			fromhost_data => fromhost_data_s,
			fromhost_write_en => fromhost_write_en_s,
			irq => irq_s,
			last_instruction_address => last_instruction_address_s,
			end_reached_o => end_reached_s,
			pc_enable =>  pc_enable,
			sp_init => stack_pointer_init   
		);

imem_unit : instruction_memory 
    generic map (imem_size => imem_size)
	port  map (
		clock => clk,
		imem_address => imem_address_arbiter,
		imem_data_out => imem_data_in_s,
		imem_req_in  => imem_req_s, 
		imem_ack_out => imem_ack_s,
		axi_write_en  => valid_in_instr,  -- apo thn eisoddo sth mnhmh
	    axi_instructions_in => instr_data -- to idio 
	);
	
dmem_unit : data_memory
    generic map (dmem_size => dmem_size)
	port map (
		clk => clk, -- egw to evala
		dmem_address => dmem_address_arbiter ,
		dmem_data_in  => dmem_data_in_arbiter, 
		dmem_data_out => dmem_data_in_s,
		dmem_data_size => dmem_data_size_arbiter,
		dmem_read_req => dmem_read_req_arbiter,
		dmem_read_ack  => dmem_read_ack_s,
		dmem_write_req => dmem_write_req_arbiter,
		dmem_write_ack => dmem_write_ack_s
	);
	
--    clk_gated_mem <= clk and (clk_en_dmem or (not pc_enable)); --egw to evala 

instruction_process: process (clk)
    begin
        if (clk'event and clk = '1') then
            if (rstn = '0') then			-- Orfea attention: always vaze synchronous reset kai negative asserted 
                  instr_mem_cnt <= (others => '0'); -- gia na grapsei to prwto stoixeio sto 0 kai oxi sto 1
            else
				if (valid_in_instr = '1') then		-- an exoume valid shma, tote grafoume kai auksanoume counter
                  	--Instr_RAM(instr_mem_cnt) <= instr_data;	-- opws to exeis ulopoihsei esu
					instr_mem_cnt <= std_logic_vector(unsigned(instr_mem_cnt) + 4);
					
				end if;
				
				if ( to_integer(unsigned(addresses_mem_cnt)) = 4) then -- send exactly small_ram_size data in this small ram!!!!!!
                    instr_mem_cnt <= (others => '0');
                end if;
			end if;
            
        end if;
end process;

	
--	mux for selecting inputs from axi or from potato core -------
imem_address_arbiter <= instr_mem_cnt when valid_in_instr = '1' else imem_address_s;

---------------------------------------------------------
--

   
   
small_ram_process: process (clk)
begin
if (clk'event and clk = '1') then
    if (rstn = '0') then 
        addresses_mem_cnt <= (others => '0');
        small_address_ram <= (others => (others => '0'));

    else
        if (valid_in_data_adresses = '1') then -- 
            addresses_mem_cnt <= std_logic_vector(unsigned(addresses_mem_cnt) + 1);
            small_address_ram(to_integer(unsigned(addresses_mem_cnt))) <= data_addresses;
        
            if ( to_integer(unsigned(addresses_mem_cnt)) = 4) then -- send exactly small_ram_size data in this small ram!!!!!!
                addresses_mem_cnt <= (others => '0');
            end if;

        end if;
    end if;
end if;
end process;


 valid_out_data <= valid_out_data_s;
 last_out_data_signal <= last_out_data_signal_s;
------data ram arbiter mux -----
dmem_address_arbiter <= data_in_mem_cnt when (valid_in_data = '1' and valid_out_prior = '0')  else
                        data_out_mem_cnt when (valid_out_prior = '1' and valid_in_data = '0')  else --------
					    dmem_address_s; --when ((valid_in_data = '0' and valid_out_data_s = '0') or (valid_in_data = '1' and valid_out_data_s = '1')) ;

dmem_data_size_arbiter <= "00" when valid_in_data = '1' else dmem_data_size_s;
dmem_data_in_arbiter <= data_in when valid_in_data = '1' else dmem_data_out_s;
dmem_write_req_arbiter <= '1' when valid_in_data = '1' else dmem_write_req_s;
data_out_s <= dmem_data_in_s when (valid_out_prior = '1' and ready_axis_stream_data_out = '1') else (others => '0');
dmem_read_req_arbiter <= '1' when (valid_out_prior = '1' and ready_axis_stream_data_out = '1') else dmem_read_req_s;

data_out <= data_out_s;

data_in_process: process (clk)
    begin
        if (clk'event and clk = '1') then
            if (  rstn = '0') then			
				PC_enable <= '0';
				data_in_mem_cnt <= (others => '0');
				stack_pointer_init <= '0';
            else
  
  
                if ( to_integer(unsigned(addresses_mem_cnt)) = 4) then   
                    data_in_mem_cnt <= small_address_ram(1)(31 downto 0);
                
				else 
					if (valid_in_data = '1') then		
						 data_in_mem_cnt <= std_logic_vector(unsigned(data_in_mem_cnt) + 4);
						 
						 if ( data_in_mem_cnt = std_logic_vector(unsigned(small_address_ram(2)(31 downto 0)) - 4) ) then
					       data_in_mem_cnt <= small_address_ram(1)(31 downto 0);
					       pc_enable <= '1';
					       stack_pointer_init <= '1';
					     --else
					     --  stack_pointer_init <= '0';  
					     end if; 
						 
					else
					   stack_pointer_init <= '0';  

					   if  (end_reached_s = '1') then
					       pc_enable <= '0';
                       end if;
				    end if;
					
			    end if;
		    end if;
        end if;
end process;




process (clk)
    begin
	if (clk'event and clk = '1') then
        if (rstn = '0') then
	    	data_out_mem_cnt <= (others => '0');
			last_out_data_signal_s <= '0';
			valid_out_data_s <= '0';
		    valid_out_prior <= '0';	
	    else
			
			  if (end_reached_s = '1') then 
			     valid_out_prior <= '1';
     			 data_out_mem_cnt <= small_address_ram(3)(31 downto 0); 
			 	
			   else 
			     if (valid_out_prior = '1') then
					valid_out_data_s <= '1';	
					
					   if (ready_axis_stream_data_out = '1') then 	-- if channel is ready to receive data
                            data_out_mem_cnt <= std_logic_vector(unsigned(data_out_mem_cnt) + 4);
                            
                        if (data_out_mem_cnt = std_logic_vector(unsigned(small_address_ram(4)(31 downto 0)) - 4)) then  
							last_out_data_signal_s <= '1';				 -- raise the last out signal
						elsif (data_out_mem_cnt = std_logic_vector(unsigned(small_address_ram(4)(31 downto 0)))) then 	
							last_out_data_signal_s <= '0';				 
							valid_out_data_s <= '0';
	                        valid_out_prior <= '0';

							
						end if;
					end if;
				end if;
			end if; --else
		end if; --rst
	end if;
end process;




	


process(clk)
begin 
	if (clk'event and clk = '1') then
	   if (rstn = '0') then 
	       last_instruction_address_s <= (others => '0');
	   else 
		  last_instruction_address_s <= small_address_ram(0);
	   end if; 
	 end if;
end process;	
			




	
end  behavioral;	
		