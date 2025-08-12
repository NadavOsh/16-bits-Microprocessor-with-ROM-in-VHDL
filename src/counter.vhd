LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.all;

ENTITY counter IS
PORT (
  Resetn, MClock : IN STD_LOGIC;
  cout : out STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END counter;

ARCHITECTURE Behavior OF counter IS

signal count: STD_LOGIC_VECTOR(6 DOWNTO 0);
begin

process(MClock, Resetn)
begin
  if Resetn = '0' then
    count <= (others => '0');
  
  elsif rising_edge(MClock) then
    if count = "1111111" then
      count <= (others => '0');
    else
      count <= count + 1;
    end if;
  end if;
end process;

cout <= count;

end Behavior;
