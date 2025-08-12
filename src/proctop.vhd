LIBRARY ieee; USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY proctop IS
PORT ( SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
LEDR : BUFFER STD_LOGIC_VECTOR(17 DOWNTO 0)
);
END proctop;


ARCHITECTURE Behavior OF proctop IS

COMPONENT proc IS
PORT ( DIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
Resetn, Clock, Run : IN STD_LOGIC;
Done : BUFFER STD_LOGIC;
BusWires : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

--signal sdone: STD_LOGIC;
--SIGNAL sbuswires : STD_LOGIC_VECTOR(15 downto 0);
signal nclk: STD_LOGIC;


begin
nclk<= NOT KEY(1);
procinst: proc PORT MAP (SW(15 downto 0), KEY(0), nclk, SW(17), LEDR(17), LEDR(15 downto 0));
--LEDR(17)<=sdone;
--LEDR(15 downto 0)<=sbuswires;

end;