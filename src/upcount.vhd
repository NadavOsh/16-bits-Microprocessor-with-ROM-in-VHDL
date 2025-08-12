LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
ENTITY upcount IS
PORT ( Clear, Clock : IN STD_LOGIC;
Q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END upcount;
ARCHITECTURE Behavior OF upcount IS
SIGNAL Count : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
PROCESS (Clock, clear)
begin
if clear='1' then
Count <= "00";
ELSE
if (clock'event and clock='1') then

Count <= Count + 1;
END IF;
END IF;
END PROCESS;
Q <= Count;
END Behavior;