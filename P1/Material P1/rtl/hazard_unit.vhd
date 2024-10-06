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
use ieee.numeric_std.all;          
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
      MemRead_EX  : in  std_logic;                     -- Instrucción en EX es una Load
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
   ForwardA <= "01" when ((unsigned(RS1_EX) = unsigned(RD_ME)) and (RegWrite_ME = '1')) and (unsigned(RS1_EX) /= "00000") else
               "10" when ((unsigned(RS1_EX) = unsigned(RD_WB)) and (RegWrite_WB  = '1')) and (unsigned(RS1_EX) /= "00000") else
               "00";

   ForwardB <= "01" when ((unsigned(RS2_EX) = unsigned(RD_ME)) and (RegWrite_ME = '1')) and (unsigned(RS2_EX) /= "00000") else
               "10" when ((unsigned(RS2_EX) = unsigned(RD_WB)) and (RegWrite_WB  = '1')) and (unsigned(RS2_EX) /= "00000") else
               "00";
--Forwarding Unit
  --process(RS1_EX)
  --begin
  -- if((unsigned(RS1_EX) = unsigned(RD_ME)) and RegWrite_ME /= '0') and (unsigned(RS1_EX) /= 0) then
  --    ForwardA <= "01";
  -- elsif((unsigned(RS1_EX) = unsigned(RD_WB)) and (RegWrite_WB  /= '0')) and (unsigned(RS1_EX) /= 0) then
  --    ForwardA <= "10";
  -- else 
  --    ForwardA <= "00";
  -- end if;

  --end process;

 -- process(RS2_EX)
 -- begin
 --  if((unsigned(RS2_EX) = unsigned(RD_ME)) and (RegWrite_ME /= '0')) and (unsigned(RS2_EX) /= 0) then
 --     ForwardB <= "01";
  -- elsif((unsigned(RS2_EX) = unsigned(RD_WB)) and ((RegWrite_WB) /= '0')) and (unsigned(RS2_EX) /= 0) then
  --    ForwardB <= "10";
 --  else 
 --     ForwardB <= "00";
 --  end if;

 -- end process;


  --Hazard detection unit for LW - Use
  process(RS1_ID, RS2_ID, RD_EX, MemRead_EX)
  begin
   if ((unsigned(RS1_ID) = unsigned(RD_EX)) or (unsigned(RS2_ID) = unsigned(RD_EX)) and MemRead_EX = '1') then
      stall_pipe <= '1'


  --stall_pipe <= '1' when ((unsigned(RS1_ID) = unsigned(RD_EX)) or (unsigned(RS2_ID) = unsigned(RD_EX)) and MemRead_EX = '1'); -- funcionamiento normal. No detenciones
  

end architecture;
