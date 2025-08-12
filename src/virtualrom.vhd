-- behavioral_memory.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY virtualrom IS
  PORT (
    address : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    clock   : IN STD_LOGIC;
    q       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END virtualrom;

ARCHITECTURE sim OF virtualrom IS
  TYPE mem_array IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL rom : mem_array := (
    0 => x"0011",
    1 => x"0011",
    2 => x"0081",
    3 => x"001A",
    4 => x"0011",
    5 => x"0041",
    6 => x"A510",
    7 => x"C0FF",
    8 => x"2C00",
    9 => x"1080",
    10 => x"AD80",
    11 => x"9280",
    OTHERS => (others => '0')
  );

BEGIN
  PROCESS (clock)
  BEGIN
    IF rising_edge(clock) THEN
      q <= rom(to_integer(unsigned(address)));
    END IF;
  END PROCESS;
END sim;
