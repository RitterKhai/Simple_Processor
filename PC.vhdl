LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;
ENTITY PC IS
PORT ( 	D: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			CLK, Reset, E, L: IN STD_LOGIC;
			Q: OUT STD_LOGIC_VECTOR(8 downto 0));
END PC;
ARCHITECTURE Behavioral OF PC IS
BEGIN
PROCESS(CLK, Reset)
VARIABLE count: STD_LOGIC_VECTOR (8 downto 0);
BEGIN
	IF (Reset = '0') THEN
		Count := (others => '0');
	ELSIF rising_edge(CLK) THEN
	IF E = '1' THEN
		count := count + "000000001";
	ELSIF L = '1' THEN
		count := D;
	END IF;
		Q <= count;
	END IF;
END PROCESS;
END Behavioral;
