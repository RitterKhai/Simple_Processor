LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY regn IS
generic (n: natural:= 9); 
PORT ( 	D : IN STD_LOGIC_VECTOR(n-1 downto 0);
			Clk, Reset, Load :IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(n-1 downto 0));
END regn;
ARCHITECTURE behavioral OF regn IS
BEGIN
	PROCESS (Clk, Reset) 
	BEGIN
		IF (Reset = '0') THEN
			Q <= (others => '0');
		ELSIF Load = '1' AND rising_edge(Clk) THEN
			Q <= D;
		END IF;
END PROCESS;
END behavioral;