LIBRARY ieee; 
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY proc IS
PORT (
  DIN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  Resetn, Clock, Run : IN STD_LOGIC;
  Done : BUFFER STD_LOGIC;
  BusWires : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END proc;

ARCHITECTURE Behavior OF proc IS

-- Components
COMPONENT regn
  GENERIC (n : INTEGER := 16);
  PORT (
    R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    Rin, Clock,resetn : IN STD_LOGIC;
    Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0)
  );
END COMPONENT;

COMPONENT regir
  GENERIC (n : INTEGER := 9);
  PORT (
    R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    Rin, Clock : IN STD_LOGIC;
    Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0)
  );
END COMPONENT;

COMPONENT upcount
  PORT (
    Clear, Clock : IN STD_LOGIC;
    Q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END COMPONENT;

COMPONENT dec3to8
  PORT (
    W : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    En : IN STD_LOGIC;
    Y : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

COMPONENT AddSub
  PORT (
    A, B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    Sub : IN STD_LOGIC;
    S : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

-- Signals
SIGNAL IR : STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL Rin, Rout, Xreg, Yreg : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL IRin, Ain, Gin, Gout, DINout, AddSubCtrl : STD_LOGIC;
SIGNAL Tstep_Q : STD_LOGIC_VECTOR(1 DOWNTO 0); 
SIGNAL A, G, ALU_result : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL I : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL Clear, High : STD_LOGIC := '1';
SIGNAL R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(15 DOWNTO 0);

-- Component instantiation
BEGIN

Clear <= (NOT Resetn) OR (NOT Run);

Tstep: upcount PORT MAP (Clear, Clock, Tstep_Q);

addsuninst: AddSub PORT MAP (A, BusWires, AddSubCtrl, ALU_result);
reg_IR: regir PORT MAP (DIN(8 downto 0), IRin, Clock, IR);
reg_A:  regn PORT MAP (BusWires, Ain, Clock, resetn, A);
reg_G:  regn PORT MAP (ALU_result, Gin, Clock, resetn, G);

reg_0:  regn PORT MAP (BusWires, Rin(0), Clock,resetn, R0);
reg_1:  regn PORT MAP (BusWires, Rin(1), Clock,resetn, R1);
reg_2:  regn PORT MAP (BusWires, Rin(2), Clock,resetn, R2);
reg_3:  regn PORT MAP (BusWires, Rin(3), Clock,resetn, R3);
reg_4:  regn PORT MAP (BusWires, Rin(4), Clock,resetn, R4);
reg_5:  regn PORT MAP (BusWires, Rin(5), Clock,resetn, R5);
reg_6:  regn PORT MAP (BusWires, Rin(6), Clock,resetn, R6);
reg_7:  regn PORT MAP (BusWires, Rin(7), Clock,resetn, R7);

-- BusWires MUX
BusWires <=
  (others => '0') when resetn='0' else
  R0 when Rout(0) = '1' else
  R1 when Rout(1) = '1' else
  R2 when Rout(2) = '1' else
  R3 when Rout(3) = '1' else
  R4 when Rout(4) = '1' else
  R5 when Rout(5) = '1' else
  R6 when Rout(6) = '1' else
  R7 when Rout(7) = '1' else
  G when Gout = '1' else
  DIN when DINout = '1' else
  (others => '0');  -- default value






-- Decoder Instantiations
I <= IR(2 downto 0);
decX: dec3to8 PORT MAP (IR(5 downto 3), High, Xreg);
decY: dec3to8 PORT MAP (IR(8 downto 6), High, Yreg);

-- Control logic
controlsignals: PROCESS (Tstep_Q, I, Xreg, Yreg, resetn)
BEGIN
if resetn='0' then
 IRin     <= '0';
  Ain      <= '0';
  Gin      <= '0';
  Gout     <= '0';
  DINout   <= '0';
  Rin      <= (others => '0');
  Rout     <= (others => '0');
  Done     <= '0';

  
  else


  -- RESET ALL CONTROL SIGNALS EACH STEP
  IRin     <= '0';
  Ain      <= '0';
  Gin      <= '0';
  Gout     <= '0';
  DINout   <= '0';
  Rin      <= (others => '0');
  Rout     <= (others => '0');
  Done     <= '0';

  CASE Tstep_Q IS
    WHEN "00" => -- T0: Fetch
      IRin <= '1';
		done<='0';

    WHEN "01" => -- T1: Decode / start execute
      CASE I IS
        WHEN "000" =>  -- Move Rx <- Ry
          Rout <= Yreg;
          Rin <= Xreg;
          Done <= '1';

        WHEN "001" =>  -- Load Rx <- DIN
          DINout <= '1';
          Rin <= Xreg;
          Done <= '1';

        WHEN "010" =>  -- Add: A <- Rx
          Rout <= Xreg;
          Ain <= '1';

        WHEN "011" =>  -- Sub: A <- Rx
          Rout <= Xreg;
          Ain <= '1';

        WHEN OTHERS =>
          Done <= '0';
      END CASE;

    WHEN "10" => -- T2: ALU operation
      CASE I IS
        WHEN "010" =>  -- ADD
          Rout <= Yreg;
          AddSubCtrl <= '0'; -- Add
          Gin <= '1';

        WHEN "011" =>  -- SUB
          Rout <= Yreg;
          AddSubCtrl <= '1'; -- Subtract
          Gin <= '1';

        WHEN OTHERS =>
          Done <= '0';
      END CASE;

    WHEN "11" => -- T3: Store ALU result
      CASE I IS
        WHEN "010" | "011" =>
          Gout <= '1';
          Rin <= Xreg;
          Done <= '1';

        WHEN OTHERS =>
          Done <= '0';
      END CASE;

    WHEN OTHERS =>
      Done <= '0';
  END CASE;
  
  end if;
END PROCESS;

END Behavior;
