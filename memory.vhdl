library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity memory is
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
end memory;
architecture arch of memory is
type ram_type is array (0 to addr_width-1) of std_logic_vector(data_width-1 downto 0);
signal user_RAM : ram_type;
attribute ram_init_file : string;
attribute ram_init_file of user_RAM : signal is "ram_data.mif";
begin
process(Clk, Write_EN)
begin
	if Rising_edge(Clk) then
		if Write_EN = '1' then
			user_RAM(to_integer(unsigned(ADDR))) <= DATA_IN;
		end if;
	end if;
end process;
DATA_OUT <= user_RAM (to_integer(unsigned(ADDR))) WHEN (Write_EN = '0') 
ELSE"000000000";
end arch;