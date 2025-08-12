LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY topwithmem IS
PORT (
  SW : IN STD_LOGIC_VECTOR(17 DOWNTO 17);
KEY : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
LEDR : BUFFER STD_LOGIC_VECTOR(17 DOWNTO 0)
);

END topwithmem;

ARCHITECTURE Behavior OF topwithmem IS

-- Components

COMPONENT proc IS
PORT ( DIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
Resetn, Clock, Run : IN STD_LOGIC;
Done : BUFFER STD_LOGIC;
BusWires : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;



COMPONENT counter IS
PORT (
  Resetn, MClock : IN STD_LOGIC;
  cout : out STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END COMPONENT;

COMPONENT memory IS
PORT (
  address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		clock		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
);
END COMPONENT;

COMPONENT virtualrom IS
  PORT (
    address : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    clock   : IN STD_LOGIC;
    q       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;


signal npclk: STD_LOGIC;
signal nmclk: STD_LOGIC;
signal addr: STD_LOGIC_VECTOR(6 downto 0);
signal data: STD_LOGIC_VECTOR(15 downto 0);



begin
npclk<= NOT KEY(1);
nmclk<= NOT KEY(2);


procinst: proc PORT MAP (data(15 downto 0), KEY(0), npclk, SW(17), LEDR(17), LEDR(15 downto 0));

counterinst: counter PORT MAP (KEY(0), nmclk, addr(6 downto 0));

memoryinst: memory PORT MAP (addr(6 downto 0), nmclk, data(15 downto 0));



end;

