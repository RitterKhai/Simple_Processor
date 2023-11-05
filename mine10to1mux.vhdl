LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
ENTITY mine10to1mux IS
PORT ( 	Din, R0, R1 , R2, R3, R4, R5, R6, R7, Gout : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			sel : IN STD_LOGIC_VECTOR(0 TO 9);
			Outmux : OUT STD_LOGIC_VECTOR(8 DOWNTO 0));
END mine10to1mux;
architecture structural of mine10to1mux is
BEGIN
PROCESS (sel)
BEGIN
IF sel = "1000000000" THEN
	Outmux <= R0;
ELSIF sel = "0100000000" THEN
	Outmux <= R1;
ELSIF sel = "0010000000" THEN
	Outmux <= R2;
ELSIF sel = "0001000000" THEN
	Outmux <= R3;
ELSIF sel = "0000100000" THEN
	Outmux <= R4;
ELSIF sel = "0000010000" THEN
	Outmux <= R5;
ELSIF sel = "0000001000" THEN
	Outmux <= R6;
ELSIF sel = "0000000100" THEN
	Outmux <= R7;
ELSIF sel = "0000000010" THEN
	Outmux <= Gout;
ELSE
	Outmux <= Din;
END IF;
END PROCESS;
end structural;
