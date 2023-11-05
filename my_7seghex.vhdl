LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY my_7seghex IS
PORT ( C: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
Z : OUT STD_LOGIC_VECTOR(0 TO 6));
END my_7seghex;
ARCHITECTURE dataflow OF my_7seghex IS
BEGIN
With C select
	Z <= 	NOT "1111110" when "0000",
			NOT "0110000" when "0001",
			NOT "1101101" when "0010",
			NOT "1111001" when "0011",
			NOT "0110011" when "0100",
			NOT "1011011" when "0101",
			NOT "1011111" when "0110",
			NOT "1110000" when "0111",
			NOT "1111111" when "1000",
			NOT "1111011" when "1001",
			NOT "1110111" when "1010",
			NOT "0011111" when "1011",
			NOT "1001110" when "1100",
			NOT "0111101" when "1101",
			NOT "1001111" when "1110",
			NOT "1000111" when "1111",
			NOT "0000000" when OTHERS;
END dataflow;