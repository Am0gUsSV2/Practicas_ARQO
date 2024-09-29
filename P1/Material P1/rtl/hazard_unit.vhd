--------------------------------------------------------------------------------
-- Hazard Unit - Unidad de control de riesgos. ArqO 2024
-- G.Sutter ago 24.
--
-- TODO (Hacer):
-- Resolver los riesgos de datos (adelantamientos y load-use)
-- y riesgos de control (Saltos en la etapa MEM)
-- Este modulo solo tiene las interfaces y genera ceros a las salidas
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;          
use work.RISCV_pack.all;

entity Hazard_unit is
   port (
      -- Entradas Forwarding
      RegWrite_ME : in  std_logic;                     -- Escribir registro en MEM
      RegWrite_WB : in  std_logic;                     -- Escribir registro en WB
      RD_ME       : in  std_logic_vector( 4 downto 0); -- Reg escritura en MEM
      RD_WB       : in  std_logic_vector( 4 downto 0); -- Reg escritura en WB
      RS1_EX      : in  std_logic_vector( 4 downto 0); -- Reg fuente 1 en EX
      RS2_EX      : in  std_logic_vector( 4 downto 0); -- Reg fuente 2 en EX
      -- Entradas para evitar Load-Use
      MemRead_EX  : in  std_logic;                     -- Intrucción en EX es una Load
      RD_EX       : in  std_logic_vector( 4 downto 0); -- Reg lectura del Load en EX
      RS1_ID      : in  std_logic_vector( 4 downto 0); -- Reg fuente 1 en DE
      RS2_ID      : in  std_logic_vector( 4 downto 0); -- Reg fuente 2 en DE

      -- Salidas Forwarding
      ForwardA    : out std_logic_vector (1 downto 0); -- Adelantamiento operando 1
      ForwardB    : out std_logic_vector (1 downto 0); -- Adelantamiento operando 2
      -- Salidas para evitar Load-USE hazard
      stall_pipe  : out std_logic                      -- para el pipeline en IF and ID
   );
end Hazard_unit;

architecture rtl of Hazard_unit is

begin

--Forwarding Unit
  ForwardA <= "00"; --No Forwarding

  ForwardB <= "00"; --No Forwarding


  --Hazard detection unit for LW - Use
  stall_pipe <= '0'; -- funcionamiento normal. No detenciones


end architecture;
