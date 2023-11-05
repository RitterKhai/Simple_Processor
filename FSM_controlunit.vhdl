LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY FSM_controlunit IS
PORT ( 	clk, Reset, Run: IN std_logic;
			I, G: IN std_logic_vector(8 DOWNTO 0);
			G_O, Din_O: OUT std_logic;
			R_O: OUT std_logic_vector(0 TO 7);
			IR_I, ADD_SUB, A_I, G_I: OUT std_logic;
			ADDR_I, DOUT_I: OUT std_logic;
			R_I : OUT STD_LOGIC_VECTOR(0 TO 7);
			Done, incr_PC, W_D: BUFFER std_logic);
END FSM_controlunit;
ARCHITECTURE behavior OF FSM_controlunit IS
COMPONENT dec3to8
PORT ( 	W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			En : IN STD_LOGIC;
			Y : OUT STD_LOGIC_VECTOR(0 TO 7));
END COMPONENT;
TYPE state IS (IWAIT, INITIAL, MV, MVI1, MVI2, MVI3, ADD1, ADD2, ADD3, SUB1, SUB2, 
SUB3, LD1, LD2, ST1, ST2, MVNZ);
SIGNAL pr_state, nx_state: state;
SIGNAL RX_TEMP, RY_TEMP, R7_TEMP: STD_LOGIC_VECTOR (0 TO 7);
SIGNAL clear: STD_LOGIC;
BEGIN
	clear <= reset or done; 
	cst_pr: PROCESS(clk, clear)
BEGIN
	IF (clear = '0') THEN
		pr_state <= IWAIT;
	ELSIF (rising_edge(clk)) THEN
		pr_state <= nx_state;
	END IF;
END PROCESS cst_pr;
nxt_pr: PROCESS (RUN, I(8 DOWNTO 6), pr_state, Done, G)
BEGIN
CASE pr_state IS
WHEN IWAIT =>
	IF RUN = '1' THEN
		nx_state <= IWAIT;
	ELSIF (RUN = '0') THEN
		nx_state <= INITIAL;
END IF;
WHEN INITIAL =>
	IF (I(8 DOWNTO 6) ="000") THEN
		nx_state <= MV;
	ELSIF (I(8 DOWNTO 6) ="001") THEN
		nx_state <= MVI1;
	ELSIF (I(8 DOWNTO 6) ="010") THEN
		nx_state <= ADD1;
	ELSIF (I(8 DOWNTO 6) ="011") THEN
		nx_state <= SUB1;
	ELSIF (I(8 DOWNTO 6) ="100") THEN
		nx_state <= LD1;
	ELSIF (I(8 DOWNTO 6) ="101") THEN
		nx_state <= ST1;
	ELSIF (I(8 DOWNTO 6) ="110") THEN
		nx_state <= MVNZ;
	END IF;
WHEN MV =>
IF (Done = '1') THEN
	nx_state <= IWAIT;
ElSE 
	nx_state <= MV;
END IF;
WHEN MVI1 =>
	nx_state <= MVI2;
WHEN MVI2 =>
	nx_state <= MVI3;
WHEN MVI3 =>
IF (Done = '1') THEN
	nx_state <= IWAIT;
ElSE 
	nx_state <= MVI3;
END IF; 
WHEN ADD1 =>
	nx_state <= ADD2;
WHEN ADD2 =>
	nx_state <= ADD3;
WHEN ADD3 =>
IF (Done = '1') THEN
	nx_state <= IWAIT;
ElSE 
	nx_state <= ADD3;
END IF;
WHEN SUB1 =>
	nx_state <= SUB2;
WHEN SUB2 =>
	nx_state <= SUB3;
WHEN SUB3 =>
IF (Done = '1') THEN
	nx_state <= IWAIT;
ElSE 
	nx_state <= SUB3;
END IF;
WHEN LD1 =>
	nx_state <= LD2;
WHEN LD2 =>
IF (Done = '1') THEN
	nx_state <= IWAIT;
ElSE 
 nx_state <= LD2;
END IF;
WHEN ST1 =>
	nx_state <= ST2;
WHEN ST2 =>
IF (Done = '1') THEN
	nx_state <= IWAIT;
ElSE 
	nx_state <= sT2;
END IF;
WHEN MVNZ =>
IF (Done = '1') THEN
	nx_state <= IWAIT;
ElSE 
	nx_state <= MVNZ;
END IF;
WHEN OTHERS =>
	nx_state <= IWAIT;
END CASE;
END PROCESS nxt_pr;
Idec3to8_X: dec3to8 PORT MAP ( I(5 DOWNTO 3), '1', RX_TEMP);
Idec3to8_Y: dec3to8 PORT MAP ( I(2 DOWNTO 0), '1', RY_TEMP);
Idec3to8_7: dec3to8 PORT MAP ( "111", '1', R7_TEMP);
out_pr: PROCESS(pr_state)
BEGIN
CASE pr_state IS
WHEN IWAIT => 
	IR_I <= '1';
	R_I <= "00000000";
	A_I <= '0'; 
	G_I <= '0';
	R_O <= R7_TEMP;
	G_O <= '0';
	Din_O <= '0'; 
	DONE <= '0';
	ADDR_I <= '1'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
WHEN INITIAL => 
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0'; 
	G_I <= '0';
	R_O <= "00000000";
	G_O <= '0';
	Din_O <= '0'; 
	DONE <= '0';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
WHEN MV =>
	IR_I <= '0';
	R_I <= RX_TEMP;
	A_I <= '0'; 
	G_I <= '0';
	R_O <= RY_TEMP;
	G_O <= '0';
	Din_O <= '0'; 
	DONE <= '1';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
IF (RX_TEMP = "00000001") THEN
	incr_PC <= '0';
ElSE 
	incr_PC <= '1';
END IF;
WHEN MVI1 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0'; 
	G_I <= '0';
	R_O <= "00000000";
	G_O <= '0';
	Din_O <= '0';
	DONE <= '0';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '1';
WHEN MVI2 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0'; 
	G_I <= '0';
	R_O <= R7_TEMP;
	G_O <= '0';
	Din_O <= '0';
	DONE <= '0';
	ADDR_I <= '1';
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
WHEN MVI3 =>
	IR_I <= '0';
	R_I <= RX_TEMP;
	A_I <= '0'; 
	G_I <= '0';
	R_O <= "00000000";
	G_O <= '0';
	Din_O <= '1';
	DONE <= '1';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
IF (RX_TEMP = "00000001") THEN
	incr_PC <= '0';
ElSE 
	incr_PC <= '1';
END IF;
WHEN ADD1 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '1';
	G_I <= '0';
	R_O <= RX_TEMP;
	G_O <= '0';
	Din_O <= '0';
	DONE <= '0';
	ADDR_I <= '0';
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
WHEN ADD2 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0';
	G_I <= '1';
	R_O <= RY_TEMP;
	Din_O <= '0';
	G_O <= '0';
	DONE <= '0';
	ADD_SUB <= '0';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
WHEN ADD3 =>
	IR_I <= '0';
	R_I <= RX_TEMP;
	A_I <= '0';
	G_I <= '0';
	R_O <= "00000000";
	Din_O <= '0'; 
	G_O <= '1';
	DONE <= '1';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
IF (RX_TEMP = "00000001") THEN
	incr_PC <= '0';
ElSE 
	incr_PC <= '1';
END IF;
WHEN SUB1 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '1';
	G_I <= '0';
	R_O <= RX_TEMP;
	G_O <= '0';
	Din_O <= '0';
	DONE <= '0';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
WHEN SUB2 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0';
	G_I <= '1';
	R_O <= RY_TEMP;
	Din_O <= '0';
	G_O <= '0';
	DONE <= '0';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
	ADD_SUB <= '1';
WHEN SUB3 =>
	IR_I <= '0';
	R_I <= RX_TEMP;
	A_I <= '0';
	G_I <= '0';
	R_O <= "00000000";
	Din_O <= '0'; 
	G_O <= '1';
	DONE <= '1';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
IF (RX_TEMP = "00000001") THEN
	incr_PC <= '0';
ElSE 
	incr_PC <= '1';
END IF;
WHEN LD1 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0';
	G_I <= '0';
	R_O <= RY_TEMP;
	Din_O <= '0'; 
	G_O <= '0';
	DONE <= '0';
	ADDR_I <= '1'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '0';
WHEN LD2 =>
	IR_I <= '0';
	R_I <= RX_TEMP;
	A_I <= '0';
	G_I <= '0';
	R_O <= "00000000";
	Din_O <= '1'; 
	G_O <= '0';
	DONE <= '1';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
IF (RX_TEMP = "00000001") THEN
	incr_PC <= '0';
ElSE 
	incr_PC <= '1';
END IF;
WHEN ST1 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0';
	G_I <= '0';
	R_O <= RX_TEMP;
	Din_O <= '0'; 
	G_O <= '0';
	DONE <= '0';
	ADDR_I <= '0'; 
	DOUT_I <= '1';
	W_D <= '0';
	incr_PC <= '0';
WHEN ST2 =>
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '1';
	G_I <= '0';
	R_O <= RY_TEMP;
	Din_O <= '0'; 
	G_O <= '0';
	DONE <= '1';
	ADDR_I <= '1'; 
	DOUT_I <= '0';
	W_D <= '1';
	incr_PC <= '1';
WHEN MVNZ =>
IF (G = "00000000") THEN
	IR_I <= '0';
	R_I <= "00000000";
	A_I <= '0'; 
	G_I <= '0';
	R_O <= "00000000";
	G_O <= '0';
	Din_O <= '0'; 
	DONE <= '1';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
	incr_PC <= '1';
ElSE 
	IR_I <= '0';
	R_I <= RX_TEMP;
	A_I <= '0'; 
	G_I <= '0';
	R_O <= RY_TEMP;
	G_O <= '0';
	Din_O <= '0'; 
	DONE <= '1';
	ADDR_I <= '0'; 
	DOUT_I <= '0';
	W_D <= '0';
IF (RX_TEMP = "00000001") THEN
	incr_PC <= '0';
ElSE 
	incr_PC <= '1';
END IF;
END IF;
WHEN OTHERS =>
	DONE <= '0';
END CASE;
END PROCESS out_pr;
END behavior;
