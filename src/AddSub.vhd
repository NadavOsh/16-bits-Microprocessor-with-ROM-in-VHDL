LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all; -- Signed arithmetic

ENTITY AddSub IS
  PORT (
    A, B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    Sub : IN STD_LOGIC; -- '0' = Add, '1' = Subtract
    S : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END AddSub;

ARCHITECTURE Behavior OF AddSub IS
BEGIN
  PROCESS (A, B, Sub)
  BEGIN
    IF Sub = '0' THEN
      S <= A + B;
    ELSE
      S <= A - B;
    END IF;
  END PROCESS;
END Behavior;
