LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY dec3to8 IS
PORT ( W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
En : IN STD_LOGIC;
Y : OUT STD_LOGIC_VECTOR(7 downto 0));
END dec3to8;
ARCHITECTURE Behavior OF dec3to8 IS
BEGIN
PROCESS (W, En)
begin
if En='1' then
case w is
WHEN "000" => Y <= "00000001";
WHEN "001" => Y <= "00000010";
WHEN "010" => Y <= "00000100";
WHEN "011" => Y <= "00001000";
WHEN "100" => Y <= "00010000";
WHEN "101" => Y <= "00100000";
WHEN "110" => Y <= "01000000";
WHEN "111" => Y <= "10000000";
when others => Y <= "00000000";
END CASE;
ELSE
Y <= "00000000";
END IF;
END PROCESS;
END Behavior;
