LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regir IS
GENERIC (n : INTEGER := 9);
PORT ( R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
Rin, Clock : IN STD_LOGIC;
Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END regir;
ARCHITECTURE Behavior OF regir IS
BEGIN
PROCESS (Clock)
begin
if clock'event and clock='1' then
if Rin ='1' then
Q <= R;
END IF;
END IF;
END PROCESS;
END Behavior;
-- Figure 2d. Subcircuit entities for use in the processor.