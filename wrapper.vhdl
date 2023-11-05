LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;
ENTITY wrapper IS
PORT ( 	clk, Reset, Run: IN std_logic;
			Done: BUFFER STD_LOGIC;
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: OUT STD_LOGIC_VECTOR(0 TO 6);
			LEDs: OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
END wrapper;
ARCHITECTURE Behavior OF wrapper IS
COMPONENT Processor
PORT ( 	clk, Reset, Run: IN std_logic;
			DIN : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			HEX4, HEX5: OUT STD_LOGIC_VECTOR(0 TO 6);
			Done: BUFFER STD_LOGIC;
			W: BUFFER STD_LOGIC;
			ADDR, DOUT: BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0)
);
END COMPONENT;
COMPONENT memory
generic(
addr_width : integer := 128;
addr_bits : integer := 7;
data_width : integer := 9 
);
port( 	DATA_IN : in std_logic_vector(data_width-1 downto 0);
			ADDR : in std_logic_vector(addr_bits-1 downto 0);
			Clk : in std_logic;
			Write_EN : in std_logic;
			DATA_OUT : out std_logic_vector(data_width-1 downto 0)
);
end COMPONENT;
COMPONENT regn
generic (n: natural:= 9); 
PORT ( 	D : IN STD_LOGIC_VECTOR(n-1 downto 0);
			Clk, Reset, Load :IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(n-1 downto 0));
END COMPONENT;
COMPONENT my_7seghex IS
PORT ( 	C: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Z : OUT STD_LOGIC_VECTOR(0 TO 6));
END COMPONENT;
SIGNAL WR_en, ADDR7xnoR8, ADDRn7xnoR8, W, WRen, E: STD_LOGIC;
SIGNAL ADDR, DOUT, Din, DATA_OUT, DATA_IN: STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL ADDR_mem: STD_LOGIC_VECTOR(6 DOWNTO 0); 
BEGIN
DATA_IN <= DOUT;
Din <= DATA_OUT;
ADDR_mem <= ADDR(6 DOWNTO 0);
ADDR7xnoR8 <= ADDR(7) xnor ADDR(8);
ADDRn7xnoR8 <= NOT(ADDR(7)) xnor ADDR(8);
WR_en <= W AND ADDR7xnoR8;
E <= W AND ADDRn7xnoR8;
iProcessor: Processor PORT MAP(clk, Reset, Run, Din, HEX4, HEX5, Done, W, ADDR, DOUT);
imemory: memory PORT MAP(DATA_IN, ADDR_mem, Clk, WR_en, DATA_OUT);
iregn: regn PORT MAP(DOUT, Clk, reset, E, LEDs);
imy_7seghex_0: my_7seghex PORT MAP (Din(3 DOWNTO 0), HEX0(0 TO 6));
imy_7seghex_1: my_7seghex PORT MAP (Din(7 DOWNTO 4), HEX1(0 TO 6));
imy_7seghex_2: my_7seghex PORT MAP ("000" & Din(8), HEX2(0 TO 6));
imy_7seghex_3: my_7seghex PORT MAP (ADDR(3 DOWNTO 0), HEX3(0 TO 6));
END Behavior;
