LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn IS
GENERIC (n : INTEGER := 16);
PORT ( R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
Rin, Clock, resetn : IN STD_LOGIC;
Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END regn;
ARCHITECTURE Behavior OF regn IS
BEGIN
PROCESS (Clock, resetn)
begin
if resetn='0' then
Q<=(others => '0');
else if clock'event and clock='1' then
if Rin ='1' then
Q <= R;
END IF;
END IF;
END IF;
END PROCESS;
END Behavior;
-- Figure 2d. Subcircuit entities for use in the processor.