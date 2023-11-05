LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY mineDFFpositive_edge IS
PORT (D, Clk, RESET : IN STD_LOGIC;
Q : OUT STD_LOGIC);
END mineDFFpositive_edge;
ARCHITECTURE behavior OF mineDFFpositive_edge IS
BEGIN
PROCESS (Clk, Reset) 
BEGIN
	IF (Reset = '0') THEN
		Q <= '0';
	ELSIF rising_edge(Clk) THEN
		Q <= D;
	END IF;
END PROCESS;
END behavior;