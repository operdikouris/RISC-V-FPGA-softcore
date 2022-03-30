-- The Potato Processor - A simple processor for FPGAs
-- (c) Kristian Klomsten Skordal 2014 <kristian.skordal@wafflemail.net>
-- Report bugs and issues on <https://github.com/skordal/potato/issues>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pp_types.all;
use work.pp_utilities.all;


--! @brief
--!	Arithmetic Logic Unit (ALU).
--!
--! @details
--! 	Performs logic and arithmetic calculations. The operation to perform
--!	is specified by the user of the module.
entity pp_alu is
	port(
		x, y      : in  std_logic_vector(31 downto 0); --! Input operand.
		result    : out std_logic_vector(31 downto 0); --! Operation result.
		operation : in alu_operation                  --! Operation type.
		
	);
     attribute use_dsp : string;

end entity pp_alu;

--! @brief Behavioural description of the ALU.

architecture behaviour of pp_alu is
    attribute use_dsp of behaviour : architecture is "no";
------------------------------------
---7. Accurate and Approximate Softcore Signed Multiplier Architectures

--component approximate is
----generic (N : integer := 32; M : integer := 32); --N: width, M: height
--port(
--    a : in std_logic_vector(31 downto 0); --width of the multiplier
--    b : in std_logic_vector(31 downto 0); --height of the multiplier
--    d : in std_logic_vector(32 downto 0); --has always to be zero, only necessary since generic generate
--    p : out std_logic_vector(63 downto 0)
--);
--end component;

--signal d : std_logic_vector(16 downto 0);

--component top is
--generic (N : integer := 32; M : integer := 32);
--port(
--topa : in std_logic_vector(N-1 downto 0);
--topb : in std_logic_vector(M-1 downto 0);
--topd : in std_logic_vector(N downto 0);
--topp : out std_logic_vector(N+M-1 downto 0)
--);
--end component;



-------------------------------------
--component accurate_mul_operator is
--generic (N : INTEGER := 32);
--port( a : in std_logic_vector(N-1 downto 0);
--      b : in std_logic_vector(N-1 downto 0);
--      p : out std_logic_vector(2*N-1 downto 0));
--end component;
------------------------
--component mult_mod_32_a16_a16_a16_a16 is
--Port (
--A : in STD_LOGIC_VECTOR (31 downto 0);
--B : in STD_LOGIC_VECTOR (31 downto 0);
--PROD : out STD_LOGIC_VECTOR (63 downto 0));
--end component;

------------------

---------------
--component optimised_accurate is
--generic (N, M : integer); --N:width, M: heigth
--port(
--    a : in std_logic_vector(N-1 downto 0); --width of the multiplier
--    b : in std_logic_vector(M-1 downto 0); --heigth of the multiplier
--    d : in std_logic_vector(N downto 0); --has always to be zero, only necessary since generic generate
--    p : out std_logic_vector(M+N-1 downto 0)
--);
--end component;

--signal d : std_logic_vector(32 downto 0);

--------------------
--component mul32x32_125 is
   
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_110 is
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_100 is
   
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_090 is
   
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_075 is
   
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_050 is
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_030 is
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_020 is
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_010 is
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_002 is
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mul32x32_000 is
--	port
--	(
--		A : in std_logic_vector(31 downto 0);
--		B : in std_logic_vector(31 downto 0);
--		Z : out std_logic_vector(63 downto 0)
--	);
--end component;

--component mult_16x16 is 
--port (
--a : in std_logic_vector(15 downto 0); 
--b : in std_logic_vector(15 downto 0);
--prod : out std_logic_vector(31 downto 0)
--); 
--end component; 

--component Approx16x16MultLit is 
--port ( 
--a : in std_logic_vector(15 downto 0); 
--b : in std_logic_vector(15 downto 0); 
--output : out std_logic_vector(31 downto 0)
--); 
--end component; 

--component Approx16x16MultV1 is 
--port ( 
--a : in std_logic_vector(15 downto 0); 
--b : in std_logic_vector(15 downto 0); 
--output : out std_logic_vector(31 downto 0)
--); 
--end component; 
----------------------------------------
--signal xmul,ymul : std_logic_vector(31 downto 0);
 
--signal pmul : std_logic_vector(3 downto 0); --14 but trunc
--signal pmul : std_logic_vector(7 downto 0); --12 but trunc
--signal pmul : std_logic_vector(11 downto 0); --10 but trunc
--signal pmul : std_logic_vector(15 downto 0); --8 bit trunc
--signal pmul : std_logic_vector(19 downto 0); --6 bit trunc 
--signal pmul : std_logic_vector(23 downto 0);  -- 4 bit trunc 
--signal pmul : std_logic_vector(27 downto 0);  -- 2 bit trunc 
signal pmul : std_logic_vector(31 downto 0); -- accurate

--=========approx add -------
--signal add_out : std_logic_vector(27 downto 0); --4 bit trunc
--signal add_out : std_logic_vector(23 downto 0); --8 bit trunc
--signal add_out : std_logic_vector(19 downto 0); --12 bit trunc
--signal add_out : std_logic_vector(15 downto 0); -- 16 bit trunc
--signal add_out : std_logic_vector(11 downto 0); --20 bit trunc 
--signal add_out : std_logic_vector(7 downto 0); -- 24 bit trunc 
--signal add_out : std_logic_vector(3 downto 0); -- 28 bit trunc
--=======================

signal x_and, y_and : std_logic_vector(31 downto 0);
signal x_or, y_or : std_logic_vector(31 downto 0);
signal x_xor, y_xor : std_logic_vector(31 downto 0); 
signal x_slt, y_slt : std_logic_vector(31 downto 0);
signal x_sltu, y_sltu : std_logic_vector(31 downto 0);
signal x_add, y_add : std_logic_vector(31 downto 0); 
signal x_sub, y_sub : std_logic_vector(31 downto 0);

--signal x_mul, y_mul : std_logic_vector(1 downto 0); --14 bit trunc 
--signal x_mul, y_mul : std_logic_vector(3 downto 0); --12 bit trunc 
--signal x_mul, y_mul : std_logic_vector(5 downto 0); --10 bit trunc 
--signal x_mul, y_mul : std_logic_vector(7 downto 0); --8 bit trunc 
--signal x_mul, y_mul : std_logic_vector(9 downto 0); --6 bit trunc 
--signal x_mul, y_mul : std_logic_vector(11 downto 0); --4 bit trunc  
--signal x_mul, y_mul : std_logic_vector(13 downto 0); --2 bit trunc  
signal x_mul, y_mul : std_logic_vector(15 downto 0); --accurate
--======approx add ==============
--signal x_xadd, y_xadd : std_logic_vector(27 downto 0); --4 bit 
--signal x_xadd, y_xadd : std_logic_vector(23 downto 0); --8 bit 
--signal x_xadd, y_xadd : std_logic_vector(19 downto 0); --12 bit 
--signal x_xadd, y_xadd : std_logic_vector(15 downto 0); --16 bit
--signal x_xadd, y_xadd : std_logic_vector(11 downto 0); -- 20 bit  
--signal x_xadd, y_xadd : std_logic_vector(7 downto 0); -- 24 bit 
--signal x_xadd, y_xadd : std_logic_vector(3 downto 0); -- 28 bit
--==========================
--=========approx mul ==============
signal x_xmul, y_xmul : std_logic_vector(15 downto 0); -- 0 bit trunc 
signal x_pmul : std_logic_vector(31 downto 0); -- 0 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(14 downto 0); -- 1 bit trunc 
--signal x_pmul : std_logic_vector(29 downto 0); --1 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(13 downto 0); -- 2 bit trunc 
--signal x_pmul : std_logic_vector(27 downto 0); --2 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(12 downto 0); -- 3 bit trunc 
--signal x_pmul : std_logic_vector(25 downto 0); --3 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(11 downto 0); -- 4 bit trunc 
--signal x_pmul : std_logic_vector(23 downto 0); --4 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(10 downto 0); -- 5 bit trunc 
--signal x_pmul : std_logic_vector(21 downto 0); --5 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(9 downto 0); -- 6 bit trunc 
--signal x_pmul : std_logic_vector(19 downto 0); --6 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(8 downto 0); -- 7 bit trunc 
--signal x_pmul : std_logic_vector(17 downto 0); --7 bit trunc 
--signal x_xmul, y_xmul : std_logic_vector(7 downto 0); -- 8 bit 
--signal x_pmul : std_logic_vector(15 downto 0); -- 8 bit 
--signal x_xmul, y_xmul : std_logic_vector(5 downto 0); -- 10 bit 
--signal x_pmul : std_logic_vector(11 downto 0); -- 10 bit 
--signal x_xmul, y_xmul : std_logic_vector(3 downto 0); -- 12 bit 
--signal x_pmul : std_logic_vector(7 downto 0); -- 12 bit 
--signal x_xmul, y_xmul : std_logic_vector(1 downto 0); -- 14 bit 
--signal x_pmul : std_logic_vector(3 downto 0); -- 14 bit 
--signal x_xmul, y_xmul : std_logic_vector(15 downto 0); --used for approximate components
--signal x_pmul : std_logic_vector(31 downto 0); --same 
--======================
signal x_srl, y_srl : std_logic_vector(31 downto 0); 
signal x_sll, y_sll : std_logic_vector(31 downto 0); 
signal x_sra, y_sra : std_logic_vector(31 downto 0);  

signal result_and : std_logic_vector(31 downto 0); 
signal result_or : std_logic_vector(31 downto 0); 
signal result_xor : std_logic_vector(31 downto 0);
signal result_slt:  std_logic_vector(31 downto 0); 
signal result_sltu: std_logic_vector(31 downto 0); 
signal result_add : std_logic_vector(31 downto 0); 
signal result_sub : std_logic_vector(31 downto 0); 
signal result_mul : std_logic_vector(31 downto 0);
--signal result_xadd : std_logic_vector(31 downto 0);
signal result_xmul : std_logic_vector(31 downto 0);
signal result_srl : std_logic_vector(31 downto 0); 
signal result_sll : std_logic_vector(31 downto 0); 
signal result_sra : std_logic_vector(31 downto 0); 


begin
    
    
--    xmul <= x when operation = ALU_MUL else (others => '0');
--    ymul <= y when operation = ALU_MUL else (others => '0');


pmul <= std_logic_vector(signed(x_mul) * signed(y_mul));
x_pmul <= std_logic_vector(signed(x_xmul) * signed(y_xmul)); 
--add_out <= std_logic_vector(unsigned(x_xadd) + unsigned(y_xadd));

--inst_mul: accurate_mul_operator
--generic map (N => 32)
--port map (a => x_mul, b => y_mul, p => pmul);

-------------------
-----7. Accurate and Approximate Softcore Signed Multiplier Architectures

--inst1_mul: approximate 
----generic map (M => 16, N => 16)
--port map (
--    a => x_mul,
--    b => y_mul, 
--    d => d, 
--    p => pmul);

--d <= (others => '0');

--inst_mul : top 
--generic map (M => 16, N =>16)
--port map (
--topa =>x_xmul, 
--topb => y_xmul, 
--topd => d,
--topp => x_pmul);

--d <= (others => '0');

---------------------
--inst1_mul: optimised_accurate
--generic map (M => 32, N => 32)
--port map (
--    a => x_mul,
--    b => y_mul, 
--    d => d, 
--    p => pmul);

--d <= (others => '0');

-----------------
--inst1_mult: mult_mod_32_a16_a16_a16_a16
--port map (
--    A => x_mul,
--    B => y_mul, 
--    PROD => pmul);
--------------
 --------------evo approx mul components  --------   
--   inst1_mult:  mul32x32_125
--        port map( 
--        A => x_mul,
--        B => y_mul,
--        Z => pmul
--);
--inst1_mult:  mul32x32_110
--        port map( 
--        A => x_mul,
--        B => y_mul,
--        Z => pmul
--);

--inst1_mult:  mul32x32_100
--        port map( 
--        A => x_mul,
--        B => y_mul,
--        Z => pmul
--);

--inst1_mult:  mul32x32_090
--        port map( 
--        A => x_mul,
--        B => y_mul,
--        Z => pmul
--);

--inst1_mult:  mul32x32_075
--        port map( 
--        A => x_xmul,
--        B => y_xmul,
--        Z => pmul
--);

--inst1_mult:  mul32x32_050
--        port map( 
--        A => x_xmul,
--        B => y_xmul,
--        Z => x_pmul
--);

--inst1_mult:  mul32x32_030
--        port map( 
--        A => x_mul,
--        B => y_mul,
--        Z => pmul
--);

--inst1_mult:  mul32x32_020
--        port map( 
--        A => x_xmul,
--        B => y_xmul,
--        Z => x_pmul
--);

--inst1_mult:  mul32x32_010
--        port map( 
--        A => x_xmul,
--        B => y_xmul,
--        Z => x_pmul
--);

--inst1_mult:  mul32x32_002
--        port map( 
--        A => x_xmul,
--        B => y_xmul,
--        Z => x_pmul
--);

--inst1_mult:  mul32x32_000
--        port map( 
--        A => x_xmul,
--        B => y_xmul,
--        Z => x_pmul
--);

--inst1_mult: mult_16x16
----generic map (word_size => 16)
--port map (
--    a => x_xmul, 
--    b => y_xmul,
--    prod => x_pmul
--    ); 

--inst1_mult: Approx16x16MultLit 
--port map (
--    a => x_xmul, 
--    b => y_xmul, 
--    output => x_pmul
--    ); 
    
--inst1_mult: Approx16x16MultV1
--port map (
--    a => x_xmul, 
--    b => y_xmul, 
--    output => x_pmul
--    ); 
------------------------------
x_and <= x when operation = ALU_AND else (others => '0'); 
y_and <= y when operation = ALU_AND else (others => '0'); 
x_or <= x when operation = ALU_OR else (others => '0'); 
y_or <= y when operation = ALU_OR else (others => '0'); 
x_xor <= x when operation = ALU_XOR else (others => '0'); 
y_xor <= y when operation = ALU_XOR else (others => '0'); 
x_slt <= x when operation = ALU_SLT else (others => '0'); 
y_slt <= y when operation = ALU_SLT else (others => '0'); 
x_sltu <= x when operation = ALU_SLTU else (others => '0'); 
y_sltu <= y when operation = ALU_SLTU else (others => '0');
 
x_add <= x when operation = ALU_ADD else (others => '0'); 
y_add <= y when operation = ALU_ADD else (others => '0'); 
x_sub <= x when operation = ALU_SUB else (others => '0'); 
y_sub <= y when operation = ALU_SUB else (others => '0'); 


--x_mul <= x(15 downto 14)  when operation = ALU_MUL else (others => '0'); -- 14 bit trunc  
--y_mul <= y(15 downto 14) when operation = ALU_MUL else (others => '0');  -- 14 bit trunc 
--x_mul <= x(15 downto 12)  when operation = ALU_MUL else (others => '0'); -- 12 bit trunc  
--y_mul <= y(15 downto 12) when operation = ALU_MUL else (others => '0');  -- 12 bit trunc 
--x_mul <= x(15 downto 10)  when operation = ALU_MUL else (others => '0'); -- 10 bit trunc  
--y_mul <= y(15 downto 10) when operation = ALU_MUL else (others => '0');  -- 10 bit trunc 
--x_mul <= x(15 downto 8)  when operation = ALU_MUL else (others => '0'); -- 8 bit trunc  
--y_mul <= y(15 downto 8) when operation = ALU_MUL else (others => '0');  -- 8 bit trunc 
--x_mul <= x(15 downto 6)  when operation = ALU_MUL else (others => '0'); -- 6 bit trunc  
--y_mul <= y(15 downto 6) when operation = ALU_MUL else (others => '0');  -- 6 bit trunc 
--x_mul <= x(15 downto 4)  when operation = ALU_MUL else (others => '0'); -- 4 bit trunc  
--y_mul <= y(15 downto 4) when operation = ALU_MUL else (others => '0');  -- 4 bit trunc
--x_mul <= x(15 downto 2)  when operation = ALU_MUL else (others => '0'); -- 2 bit trunc  
--y_mul <= y(15 downto 2) when operation = ALU_MUL else (others => '0');  -- 2 bit trunc  
x_mul <= x(15 downto 0) when operation = ALU_MUL else (others => '0'); -- accurate
y_mul <= y(15 downto 0) when operation = ALU_MUL else (others => '0'); -- accurate

---==========approx add
--x_xadd <= x(31 downto 4) when operation = ALU_XADD else (others => '0'); -- 4 bit trunc  
--y_xadd <= y(31 downto 4) when operation = ALU_XADD else (others => '0'); -- 4 bit trunc 
--x_xadd <= x(31 downto 8) when operation = ALU_XADD else (others => '0'); -- 8 bit trunc  
--y_xadd <= y(31 downto 8) when operation = ALU_XADD else (others => '0'); -- 8 bit trunc 
--x_xadd <= x(31 downto 12) when operation = ALU_XADD else (others => '0'); -- 12 bit trunc  
--y_xadd <= y(31 downto 12) when operation = ALU_XADD else (others => '0'); -- 12 bit trunc 
--x_xadd <= x(31 downto 16) when operation = ALU_XADD else (others => '0'); -- 16 bit trunc  
--y_xadd <= y(31 downto 16) when operation = ALU_XADD else (others => '0'); -- 16 bit trunc 
--x_xadd <= x(31 downto 20) when operation = ALU_XADD else (others => '0'); -- 20 bit trunc  
--y_xadd <= y(31 downto 20) when operation = ALU_XADD else (others => '0'); -- 20 bit trunc
--x_xadd <= x(31 downto 24) when operation = ALU_XADD else (others => '0'); -- 24 bit trunc  
--y_xadd <= y(31 downto 24) when operation = ALU_XADD else (others => '0'); -- 24 bit trunc
--x_xadd <= x(31 downto 28) when operation = ALU_XADD else (others => '0'); -- 28 bit trunc  
--y_xadd <= y(31 downto 28) when operation = ALU_XADD else (others => '0'); -- 28 bit trunc

---===========

--========approx mul
--x_xmul <= x(15 downto 7) & "0000000"  when operation = ALU_XMUL else (others => '0'); -- 1 bit trunc  
--y_xmul <= y(15 downto 0) when operation = ALU_XMUL else (others => '0');  -- 1 bit trunc
x_xmul <= x(15)& "000000000000000"  when operation = ALU_XMUL else (others => '0'); -- 2 bit trunc  
y_xmul <= y(15)& "000000000000000" when operation = ALU_XMUL else (others => '0');  -- 2 bit trunc
--x_xmul <= x(15 downto 3)  when operation = ALU_XMUL else (others => '0'); -- 3 bit trunc  
--y_xmul <= y(12 downto 0) when operation = ALU_XMUL else (others => '0');  -- 3 bit trunc
--x_xmul <= x(15 downto 4)  when operation = ALU_XMUL else (others => '0'); -- 4 bit trunc  
--y_xmul <= y(15 downto 4) when operation = ALU_XMUL else (others => '0');  -- 4 bit trunc
--x_xmul <= x(15 downto 5)  when operation = ALU_XMUL else (others => '0'); -- 5 bit trunc  
--y_xmul <= y(15 downto 5) when operation = ALU_XMUL else (others => '0');  -- 5 bit trunc
--x_xmul <= x(15 downto 6)  when operation = ALU_XMUL else (others => '0'); -- 6 bit trunc  
--y_xmul <= y(15 downto 6) when operation = ALU_XMUL else (others => '0');  -- 6 bit trunc
--x_xmul <= x(15 downto 7)  when operation = ALU_XMUL else (others => '0'); -- 7 bit trunc  
--y_xmul <= y(15 downto 7) when operation = ALU_XMUL else (others => '0');  -- 7 bit trunc
--x_xmul <= x(15 downto 8)  when operation = ALU_XMUL else (others => '0'); -- 8 bit trunc  
--y_xmul <= y(15 downto 8) when operation = ALU_XMUL else (others => '0');  -- 8 bit trunc
--x_xmul <= x(15 downto 10)  when operation = ALU_XMUL else (others => '0'); -- 10 bit trunc  
--y_xmul <= y(15 downto 10) when operation = ALU_XMUL else (others => '0');  -- 10 bit trunc
--x_xmul <= x(15 downto 12)  when operation = ALU_XMUL else (others => '0'); -- 12 bit trunc  
--y_xmul <= y(15 downto 12) when operation = ALU_XMUL else (others => '0');  -- 12 bit trunc
--x_xmul <= x(15 downto 14)  when operation = ALU_XMUL else (others => '0'); -- 14 bit trunc  
--y_xmul <= y(15 downto 14) when operation = ALU_XMUL else (others => '0');  -- 14 bit trunc
--x_xmul <= x(15 downto 0) when operation = ALU_XMUL else (others => '0');
--x_xmul(31 downto 16) <= (others => '0'); 
--y_xmul <= y(15 downto 0) when operation = ALU_XMUL else (others => '0');
--y_xmul(31 downto 16) <= (others => '0'); 
--==============
----==============
x_srl <= x when operation = ALU_SRL else (others => '0'); 
y_srl <= y when operation = ALU_SRL else (others => '0');
x_sll <= x when operation = ALU_SLL else (others => '0'); 
y_sll <= y when operation = ALU_SLL else (others => '0'); 
x_sra <= x when operation = ALU_SRA else (others => '0'); 
y_sra <= y when operation = ALU_SRA else (others => '0'); 
 
 result_and <= x_and and y_and ;
 result_or <= x_or or  y_or; 
 result_xor <= x_xor xor y_xor; 
 result_slt <= (0 => '1', others => '0') when signed(x_slt) < signed(y_slt) else (others => '0'); 
 result_sltu <= (0 => '1', others => '0') when unsigned(x_sltu) < unsigned(y_sltu) else (others => '0');
 result_add <= std_logic_vector(signed(x_add) + signed(y_add));
 result_sub <=  std_logic_vector(signed(x_sub) - signed(y_sub));
 
--result_mul <= pmul & "0000000000000000000000000000"; -- 14 bit trunc
--result_mul <= pmul & "000000000000000000000000"; -- 12 bit trunc
-- result_mul <= pmul & "00000000000000000000"; -- 10 bit trunc
-- result_mul <= pmul & "0000000000000000"; -- 8 bit trunc
--result_mul <= pmul & "000000000000"; -- 6 bit trunc
-- result_mul <= pmul & "00000000"; -- 4 bit trunc
--result_mul <= pmul & "0000"; -- 2 bit trunc
 result_mul <= pmul; --accurate
 
 ---- approx add 
-- result_xadd <= add_out & "0000"; -- 4 bit trunc 
--result_xadd <= add_out  & "00000000"; --8 bit trunc
--result_xadd <= add_out  & "000000000000"; -- 12 bit trunc
--result_xadd <= add_out  & "0000000000000000"; --16 bit trunc
--result_xadd <= add_out  & "00000000000000000000"; --20 bit trunc
--result_xadd <= add_out    & "000000000000000000000000"; --24 bit trunc
--result_xadd <= add_out      & "0000000000000000000000000000"; -- 28 bit trunc
-----------------

---- approx mul 
--result_xmul <= x_pmul; --0 bit 
--result_xmul <= x_pmul & "00"; --1 bit 
--result_xmul <= x_pmul & "0000"; --2 bit 
--result_xmul <= x_pmul & "000000"; --3 bit 
--result_xmul <= x_pmul & "00000000"; -- 4 bit 
--result_xmul <= x_pmul & "0000000000"; --5 bit 
--result_xmul <= x_pmul & "000000000000"; -- 6 bit 
--result_xmul <= x_pmul & "00000000000000"; --7 bit 
--result_xmul <= x_pmul & "0000000000000000";  -- 8 bit 
--result_xmul <= x_pmul & "00000000000000000000"; -- 10 bit 
--result_xmul <= x_pmul & "000000000000000000000000"; -- 12 bit 
--result_xmul <= x_pmul & "0000000000000000000000000000"; -- 14 bit 
result_xmul <= x_pmul; 

-----------

 
 result_srl <= std_logic_vector(shift_right(unsigned(x_srl), to_integer(unsigned(y_srl(4 downto 0)))));
 result_sll <= std_logic_vector(shift_left(unsigned(x_sll), to_integer(unsigned(y_sll(4 downto 0)))));
 result_sra <= std_logic_vector(shift_right(signed(x_sra), to_integer(unsigned(y_sra(4 downto 0)))));
 
 result <= result_and when operation = ALU_AND  else 
           result_or when  operation = ALU_OR else 
           result_xor when  operation = ALU_XOR else 
           result_slt when  operation = ALU_SLT else 
           result_sltu when operation = ALU_SLTU else 
           result_add when operation = ALU_ADD else 
           result_sub when operation = ALU_SUB else 
           result_mul when operation = ALU_MUL else 
           result_srl when operation = ALU_SRL else
           result_sll when operation = ALU_SLL else 
           result_sra when operation = ALU_SRA else 
--           result_xadd when operation = ALU_XADD else
           result_xmul when operation = ALU_XMUL else 
           (others => '0');


	--! Performs the ALU calculation.
--calculate: process(operation,  x, y, pmul)
--	begin
--     -- if alu_stop_in = '0' then 
--		case operation is
--			when ALU_AND =>
--				result <= x and y;
--			when ALU_OR =>
--				result <= x or y;
--			when ALU_XOR =>
--				result <= x xor y;
--			when ALU_SLT =>
--				if signed(x) < signed(y) then
--					result <= (0 => '1', others => '0');
--				else
--					result <= (others => '0');
--				end if;
--			when ALU_SLTU =>
--				if unsigned(x) < unsigned(y) then
--					result <= (0 => '1', others => '0');
--				else
--					result <= (others => '0');
--				end if;
--			when ALU_ADD =>
--				result <= std_logic_vector(unsigned(x) + unsigned(y));
--			when ALU_SUB =>
--				result <= std_logic_vector(unsigned(x) - unsigned(y));
             
--			when ALU_MUL =>
----			     result <= resize_mul(std_logic_vector(unsigned(x) * unsigned(y)));
              
--			    result <= pmul(31 downto 0);
--			when ALU_SRL =>
--				result <= std_logic_vector(shift_right(unsigned(x), to_integer(unsigned(y(4 downto 0)))));
--			when ALU_SLL =>
--				result <= std_logic_vector(shift_left(unsigned(x), to_integer(unsigned(y(4 downto 0)))));
--			when ALU_SRA =>
--				result <= std_logic_vector(shift_right(signed(x), to_integer(unsigned(y(4 downto 0)))));
--			when others =>
--				result <= (others => '0');
--		end case;
    
       
	
--	end process calculate;
	
	
end architecture behaviour;
