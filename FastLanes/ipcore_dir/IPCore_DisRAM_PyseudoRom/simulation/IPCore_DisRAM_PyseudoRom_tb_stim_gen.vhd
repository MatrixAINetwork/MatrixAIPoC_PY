--------------------------------------------------------------------------------
--
-- DIST MEM GEN Core - Stimulus Generator For Dual Port RAM Configuration
--
--------------------------------------------------------------------------------
--
-- (c) Copyright 2006_3010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

--------------------------------------------------------------------------------
--
-- Filename: IPCore_DisRAM_PyseudoRom_tb_stim_gen.vhd
--
-- Description:
--  Stimulus Generation For ROM
--
--------------------------------------------------------------------------------
-- Author: IP Solutions Division
--
-- History: Sep 12, 2011 - First Release
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
-- Library Declarations
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;

LIBRARY work;
USE work.ALL;

USE work.IPCore_DisRAM_PyseudoRom_TB_PKG.ALL;


ENTITY REGISTER_LOGIC_DRAM IS
  PORT(
    Q   : OUT STD_LOGIC;
    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;
    D   : IN STD_LOGIC
  );
END REGISTER_LOGIC_DRAM;

ARCHITECTURE REGISTER_ARCH OF REGISTER_LOGIC_DRAM IS
  SIGNAL Q_O : STD_LOGIC :='0';
BEGIN
  Q <= Q_O;
  FF_BEH: PROCESS(CLK)
  BEGIN
    IF(RISING_EDGE(CLK)) THEN
      IF(RST ='1') THEN
    	  Q_O <= '0';
      ELSE
        Q_O <= D;
      END IF;
    END IF;
  END PROCESS;
END REGISTER_ARCH;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;

LIBRARY work;
USE work.ALL;
USE work.IPCore_DisRAM_PyseudoRom_TB_PKG.ALL;

ENTITY IPCore_DisRAM_PyseudoRom_TB_STIM_GEN IS
  PORT(
    CLK : IN STD_LOGIC;
    RST : IN STD_LOGIC;
    A   : OUT  STD_LOGIC_VECTOR(9-1 downto 0)   := (OTHERS => '0'); 
    D   : OUT  STD_LOGIC_VECTOR(64-1 downto 0)        := (OTHERS => '0');
    DPRA : OUT  STD_LOGIC_VECTOR(9-1 downto 0)   := (OTHERS => '0');
    WE         : OUT  STD_LOGIC  := '0';
    DATA_IN : IN STD_LOGIC_VECTOR (63 DOWNTO 0);   --OUTPUT VECTOR 
    DATA_IN_B : IN STD_LOGIC_VECTOR (63 DOWNTO 0);   --OUTPUT VECTOR 
        
        
    CHECK_DATA : OUT STD_LOGIC_VECTOR(1 downto 0)   := (OTHERS => '0')
    	  );
END IPCore_DisRAM_PyseudoRom_TB_STIM_GEN;

ARCHITECTURE BEHAVIORAL OF IPCore_DisRAM_PyseudoRom_TB_STIM_GEN IS
  CONSTANT ZERO           : STD_LOGIC_VECTOR(31 DOWNTO 0)                := (OTHERS => '0');
  CONSTANT DATA_PART_CNT_A: INTEGER:=1;
  CONSTANT DATA_PART_CNT_B: INTEGER:=1;
  SIGNAL   WRITE_ADDR_A   : STD_LOGIC_VECTOR(31 DOWNTO 0)                := (OTHERS => '0');
  SIGNAL   WRITE_ADDR_B   : STD_LOGIC_VECTOR(31 DOWNTO 0)                := (OTHERS => '0');
  SIGNAL   WRITE_ADDR_INT_A : STD_LOGIC_VECTOR(8 DOWNTO 0)   := (OTHERS => '0');
  SIGNAL   WRITE_ADDR_INT_B : STD_LOGIC_VECTOR(8 DOWNTO 0)   := (OTHERS => '0');
  SIGNAL   DO_READ_REG_A  : STD_LOGIC_VECTOR(4 DOWNTO 0)                 :=(OTHERS => '0');
  SIGNAL   DO_READ_REG_B  : STD_LOGIC_VECTOR(4 DOWNTO 0)                 :=(OTHERS => '0');
  SIGNAL   READ_ADDR_INT_A  : STD_LOGIC_VECTOR(8 DOWNTO 0)   := (OTHERS => '0');
  SIGNAL   READ_ADDR_INT_B  : STD_LOGIC_VECTOR(8 DOWNTO 0)   := (OTHERS => '0');
  SIGNAL   READ_ADDR_A    : STD_LOGIC_VECTOR(31 DOWNTO 0)                := (OTHERS => '0');
  SIGNAL   READ_ADDR_B    : STD_LOGIC_VECTOR(31 DOWNTO 0)                := (OTHERS => '0');
  SIGNAL   D_INT_A        : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
  SIGNAL   D_INT_B        : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
  SIGNAL   DO_WRITE_A     : STD_LOGIC                                    := '0';
  SIGNAL   DO_WRITE_B     : STD_LOGIC                                    := '0';
  SIGNAL   DO_WRITE       : STD_LOGIC                                    := '0';
  SIGNAL   DO_READ_A      : STD_LOGIC                                    := '0';
  SIGNAL   DO_READ_B      : STD_LOGIC                                    := '0';
  SIGNAL COUNT : integer := 0;
  SIGNAL COUNT_B : integer := 0;
  CONSTANT WRITE_CNT_A : integer := 8;
  CONSTANT READ_CNT_A : integer := 8;
  CONSTANT WRITE_CNT_B : integer := 8;
  CONSTANT READ_CNT_B : integer := 8;
  
  signal porta_wr_rd : std_logic:='0';     
  signal portb_wr_rd : std_logic:='0';     
  signal porta_wr_rd_complete: std_logic:='0';
  signal portb_wr_rd_complete: std_logic:='0';
  signal incr_cnt : std_logic :='0';
  signal incr_cnt_b : std_logic :='0';
  
  SIGNAL PORTB_WR_RD_HAPPENED: STD_LOGIC :='0';
  SIGNAL LATCH_PORTA_WR_RD_COMPLETE : STD_LOGIC :='0';
  SIGNAL PORTA_WR_RD_L1 :STD_LOGIC :='0';
  SIGNAL PORTA_WR_RD_L2 :STD_LOGIC :='0';
  SIGNAL PORTB_WR_RD_R1 :STD_LOGIC :='0';
  SIGNAL PORTB_WR_RD_R2 :STD_LOGIC :='0';
  SIGNAL PORTA_WR_RD_HAPPENED: STD_LOGIC :='0';
  SIGNAL LATCH_PORTB_WR_RD_COMPLETE : STD_LOGIC :='0';
  SIGNAL PORTB_WR_RD_L1 :STD_LOGIC :='0';
  SIGNAL PORTB_WR_RD_L2 :STD_LOGIC :='0';
  SIGNAL PORTA_WR_RD_R1 :STD_LOGIC :='0';
  SIGNAL PORTA_WR_RD_R2 :STD_LOGIC :='0';
BEGIN
  WRITE_ADDR_INT_A(8 DOWNTO 0) <= WRITE_ADDR_A(8 DOWNTO 0);
  READ_ADDR_INT_A(8 DOWNTO 0)  <= READ_ADDR_A(8 DOWNTO 0);
  WRITE_ADDR_INT_B(8 DOWNTO 0) <= WRITE_ADDR_B(8 DOWNTO 0);
  READ_ADDR_INT_B(8 DOWNTO 0)  <= READ_ADDR_B(8 DOWNTO 0);
  A <= IF_THEN_ELSE(DO_WRITE_A='1',WRITE_ADDR_INT_A,READ_ADDR_INT_A); 
  D <= IF_THEN_ELSE(DO_WRITE_A='1',D_INT_A,D_INT_B);
  DPRA <= IF_THEN_ELSE(DO_WRITE_B='1',WRITE_ADDR_INT_B,READ_ADDR_INT_B);
  CHECK_DATA(0) <= DO_READ_A;
  CHECK_DATA(1) <= DO_READ_B;
  DO_WRITE <= DO_WRITE_A OR DO_WRITE_B;

RD_GEN_INST_A:ENTITY work.IPCore_DisRAM_PyseudoRom_TB_AGEN
  GENERIC MAP( 
    C_MAX_DEPTH => 512 
  )
  PORT MAP(
    CLK        => CLK,
    RST        => RST,
    EN         => DO_READ_A,
    LOAD       => '0',
    LOAD_VALUE => ZERO,
    ADDR_OUT   => READ_ADDR_A
  );

WR_AGEN_INST_A:ENTITY work.IPCore_DisRAM_PyseudoRom_TB_AGEN
  GENERIC MAP(
    C_MAX_DEPTH => 512  )
  PORT MAP(
    CLK        => CLK,
  	 RST        => RST,
	 EN         => DO_WRITE_A,
    LOAD       => '0',
 	 LOAD_VALUE => ZERO,
 	 ADDR_OUT   => WRITE_ADDR_A
  );

WR_DGEN_INST_A:ENTITY work.IPCore_DisRAM_PyseudoRom_TB_DGEN
  GENERIC MAP (
    DATA_GEN_WIDTH => 64,
    DOUT_WIDTH     => 64,
    DATA_PART_CNT  => DATA_PART_CNT_A,
    SEED           => 2
  )
  PORT MAP (
    CLK      => CLK,
	  RST      => RST,
    EN       => DO_WRITE_A,
    DATA_OUT => D_INT_A          
  );

RD_AGEN_INST_B:ENTITY work.IPCore_DisRAM_PyseudoRom_TB_AGEN
  GENERIC MAP( 
    C_MAX_DEPTH => 512 
  )
  PORT MAP(
    CLK        => CLK,
    RST        => RST,
    EN         => DO_READ_B,
    LOAD       => '0',
    LOAD_VALUE => ZERO,
    ADDR_OUT   => READ_ADDR_B
  );

WR_AGEN_INST_B:ENTITY work.IPCore_DisRAM_PyseudoRom_TB_AGEN
  GENERIC MAP(
    C_MAX_DEPTH => 512  )
  PORT MAP(
    CLK        => CLK,
  	 RST        => RST,
	 EN         => DO_WRITE_B,
    LOAD       => '0',
 	 LOAD_VALUE => ZERO,
 	 ADDR_OUT   => WRITE_ADDR_B
  );

WR_DGEN_INST_B:ENTITY work.IPCore_DisRAM_PyseudoRom_TB_DGEN
  GENERIC MAP (
    DATA_GEN_WIDTH => 64,
    DOUT_WIDTH     => 64,
    DATA_PART_CNT  => DATA_PART_CNT_B,
    SEED           => 2
   )
  PORT MAP (
    CLK        => CLK,
 	 RST      => RST,
    EN       => DO_WRITE_B,
    DATA_OUT => D_INT_B          
   );

PROCESS(CLK)
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      LATCH_PORTB_WR_RD_COMPLETE<='0';
    ELSIF(PORTB_WR_RD_COMPLETE='1') THEN
      LATCH_PORTB_WR_RD_COMPLETE <='1';
    ELSIF(PORTA_WR_RD_HAPPENED='1') THEN
      LATCH_PORTB_WR_RD_COMPLETE<='0';
    END IF;
  END IF;
END PROCESS;

PROCESS(CLK)
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      PORTB_WR_RD_L1 <='0';
      PORTB_WR_RD_L2 <='0';
    ELSE
     PORTB_WR_RD_L1 <= LATCH_PORTB_WR_RD_COMPLETE;
     PORTB_WR_RD_L2 <= PORTB_WR_RD_L1;
    END IF;
 END IF;
END PROCESS;

PORTA_WR_RD_EN: PROCESS(CLK)
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      PORTA_WR_RD <='1';
    ELSE
      PORTA_WR_RD <= PORTB_WR_RD_L2;
    END IF;
  END IF;
END PROCESS;

PROCESS(CLK)
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      PORTA_WR_RD_R1 <='0';
      PORTA_WR_RD_R2 <='0';
    ELSE
      PORTA_WR_RD_R1 <=PORTA_WR_RD;
      PORTA_WR_RD_R2 <=PORTA_WR_RD_R1;
    END IF;
 END IF;
END PROCESS;

PORTA_WR_RD_HAPPENED <= PORTA_WR_RD_R2;

PROCESS(CLK) 
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      LATCH_PORTA_WR_RD_COMPLETE<='0';
    ELSIF(PORTA_WR_RD_COMPLETE='1') THEN
      LATCH_PORTA_WR_RD_COMPLETE <='1';
    ELSIF(PORTB_WR_RD_HAPPENED='1') THEN
      LATCH_PORTA_WR_RD_COMPLETE<='0';
    END IF;
  END IF;
END PROCESS;

PROCESS(CLK)
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      PORTA_WR_RD_L1 <='0';
      PORTA_WR_RD_L2 <='0';
    ELSE
     PORTA_WR_RD_L1 <= LATCH_PORTA_WR_RD_COMPLETE;
     PORTA_WR_RD_L2 <= PORTA_WR_RD_L1;
    END IF;
 END IF;
END PROCESS;


PORTB_EN: PROCESS(CLK)
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      PORTB_WR_RD <='0';
    ELSE
      PORTB_WR_RD <= PORTA_WR_RD_L2;
    END IF;
  END IF;
END PROCESS;

PROCESS(CLK)
BEGIN
  IF(RISING_EDGE(CLK)) THEN
    IF(RST='1') THEN
      PORTB_WR_RD_R1 <='0';
      PORTB_WR_RD_R2 <='0';
    ELSE
      PORTB_WR_RD_R1 <=PORTB_WR_RD;
      PORTB_WR_RD_R2 <=PORTB_WR_RD_R1;
    END IF;
 END IF;
END PROCESS;

---double registered of porta complete on portb clk
PORTB_WR_RD_HAPPENED <= PORTB_WR_RD_R2; 

PORTA_WR_RD_COMPLETE <= '1' when count=(WRITE_CNT_A+READ_CNT_A) else '0';

start_counter: process(CLK)
begin
  if(rising_edge(CLK)) then
    if(RST='1') then
       incr_cnt <= '0';
     elsif(porta_wr_rd ='1') then
       incr_cnt <='1';
     elsif(porta_wr_rd_complete='1') then
       incr_cnt <='0';
     end if;
  end if;
end process;

COUNTER: process(CLK)
begin
  if(rising_edge(CLK)) then
    if(RST='1') then
      count <= 0;
    elsif(incr_cnt='1') then
      count<=count+1;
    end if;
    if(count=(WRITE_CNT_A+READ_CNT_A)) then
      count<=0;
    end if;
 end if;
end process;

DO_WRITE_A<='1' when (count <WRITE_CNT_A and incr_cnt='1') else '0';
DO_READ_A <='1' when (count >WRITE_CNT_A and incr_cnt='1') else '0';

PORTB_WR_RD_COMPLETE <= '1' when count_b=(WRITE_CNT_B+READ_CNT_B) else '0';

startb_counter: process(CLK)
begin
  if(rising_edge(CLK)) then
    if(RST='1') then
       incr_cnt_b <= '0';
     elsif(portb_wr_rd ='1') then
       incr_cnt_b <='1';
     elsif(portb_wr_rd_complete='1') then
       incr_cnt_b <='0';
     end if;
  end if;
end process;

COUNTER_B: process(CLK)
begin
  if(rising_edge(CLK)) then
    if(RST='1') then
      count_b <= 0;
    elsif(incr_cnt_b='1') then
      count_b<=count_b+1;
    end if;
    if(count_b=WRITE_CNT_B+READ_CNT_B) then
      count_b<=0;
    end if;
 end if;
end process;

DO_WRITE_B<='1' when (count_b <WRITE_CNT_B and incr_cnt_b='1') else '0';
DO_READ_B <='1' when (count_b >WRITE_CNT_B and incr_cnt_b='1') else '0';

BEGIN_SHIFT_REG: FOR I IN 0 TO 4 GENERATE
BEGIN
  DFF_RIGHT: IF I=0 GENERATE
  BEGIN
    SHIFT_INST_0: ENTITY work.REGISTER_LOGIC_DRAM
      PORT MAP(
        Q   => DO_READ_REG_A(0),
        CLK => CLK,
        RST => RST,
        D   => DO_READ_A
      );
  END GENERATE DFF_RIGHT;
  DFF_OTHERS: IF ((I>0) AND (I<=4)) GENERATE
  BEGIN
     SHIFT_INST: ENTITY work.REGISTER_LOGIC_DRAM
       PORT MAP(
          Q   => DO_READ_REG_A(I),
          CLK => CLK,
          RST => RST,
          D   => DO_READ_REG_A(I-1)
       );
  END GENERATE DFF_OTHERS;
END GENERATE BEGIN_SHIFT_REG;

BEGIN_SHIFT_REG_B: FOR I IN 0 TO 4 GENERATE
BEGIN
  DFF_RIGHT: IF I=0 GENERATE
  BEGIN
    SHIFT_INST_0: ENTITY work.REGISTER_LOGIC_DRAM
      PORT MAP(
        Q   => DO_READ_REG_B(0),
        CLK        => CLK,
        RST => RST,
        D   => DO_READ_B
      );
  END GENERATE DFF_RIGHT;
  DFF_OTHERS: IF ((I>0) AND (I<=4)) GENERATE
  BEGIN
     SHIFT_INST: ENTITY work.REGISTER_LOGIC_DRAM
       PORT MAP(
         Q   => DO_READ_REG_B(I),
         CLK        => CLK,
         RST => RST,
         D   => DO_READ_REG_B(I-1)
       );
  END GENERATE DFF_OTHERS;
END GENERATE BEGIN_SHIFT_REG_B;



  WE <= IF_THEN_ELSE(DO_WRITE='1','1','0') ;

END ARCHITECTURE;
