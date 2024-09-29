--------------------------------------------------------------------------------
-- Package for RISCV. Arq0 2024
-- G.Sutter original code jun2022 
-- Main modif ago 2024
--
-- Define constantes para diferntes módulos
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package RISCV_pack is

    -- Tipo para los codigos de operacion:
    subtype t_opCode is std_logic_vector (6 downto 0);
    -- Codigos de operacion para las diferentes instrucciones:
    constant OP_RTYPE  : t_opCode := "0110011";
    constant OP_ITYPE  : t_opCode := "0010011"; -- I-Type Arithm
    constant OP_BRANCH : t_opCode := "1100011";
    constant OP_ST     : t_opCode := "0100011";
    constant OP_LD     : t_opCode := "0000011";
    constant OP_LUI    : t_opCode := "0110111"; -- Load Upper Inmediate
    constant OP_AUIPC  : t_opCode := "0010111"; -- Load Upper Inmediate + PC
    constant OP_JAL    : t_opCode := "1101111"; -- Jump and Link
    constant OP_JALR   : t_opCode := "1100111"; -- Jump and Link Register
    constant OP_SCALL  : t_opCode := "1110011"; -- System Call. no hace nada
    constant OP_RESET  : t_opCode := "0000000"; -- When reset 
 
    -- Tipo para los codigos de control de la ALU:
    subtype t_aluControl is std_logic_vector (3 downto 0);
    subtype t_aluOP      is std_logic_vector (2 downto 0);

    -- Codigos ALUOP
    constant R_Type  : t_aluOP := "010";
    constant I_Type  : t_aluOP := "011";
    constant LDST_T  : t_aluOP := "000";
    constant BRCH_T  : t_aluOP := "001";
    constant LUI_T   : t_aluOP := "101";

    -- Codigos de control:
    constant ALU_ADD  : t_aluControl := "0010";
    constant ALU_SUB  : t_aluControl := "0110";
    constant ALU_AND  : t_aluControl := "0000";
    constant ALU_OR   : t_aluControl := "0001";
    constant ALU_NOT  : t_aluControl := "0101";
    constant ALU_XOR  : t_aluControl := "0111";
    constant ALU_SLT  : t_aluControl := "1010";
    constant ALU_LUI  : t_aluControl := "1011";
    constant ALU_S12  : t_aluControl := "1101";
    constant ALU_NIM  : t_aluControl := "XXXX"; --ALU not implemented yet

    -- Tipo para los codigos func3 en branches
    subtype t_funct3_branch   is std_logic_vector (2 downto 0);
    constant BR_F3_BEQ  : t_funct3_branch := "000";
    constant BR_F3_BNE  : t_funct3_branch := "001";
    constant BR_F3_BLT  : t_funct3_branch := "100";
    constant BR_F3_BGE  : t_funct3_branch := "101";


-- Component declaration used in RISC V design
    component alu_RV
    port (
      OpA     : in  std_logic_vector (31 downto 0); -- Operando A
      OpB     : in  std_logic_vector (31 downto 0); -- Operando B
      Control : in  std_logic_vector ( 3 downto 0); -- Codigo de control=op. a ejecutar
      Result  : out std_logic_vector (31 downto 0); -- Resultado
      SignFlag: out std_logic;                      -- Sign Flag
      CarryOut: out std_logic;                      -- Carry bit
      ZFlag   : out std_logic                       -- Flag Z
    );
    end component;

  component reg_bank
     port (
        Clk   : in  std_logic;                      -- Reloj activo en flanco de subida
        Reset : in  std_logic;                      -- Reset asincrono a nivel alto
        A1    : in  std_logic_vector(4 downto 0);   -- Direccion para el primer registro fuente (rs1)
        Rd1   : out std_logic_vector(31 downto 0);  -- Dato del primer registro fuente (rs1)
        A2    : in  std_logic_vector(4 downto 0);   -- Direccion para el segundo registro fuente (rs2)
        Rd2   : out std_logic_vector(31 downto 0);  -- Dato del segundo registro fuente (rs2)
        A3    : in  std_logic_vector(4 downto 0);   -- Direccion para el registro destino (rd)
        Wd3   : in  std_logic_vector(31 downto 0);  -- Dato de entrada para el registro destino (rd)
        We3   : in  std_logic                       -- Habilitacion de la escritura de Wd3 (rd)
     ); 
  end component reg_bank;

  component control_unit
     port (
        -- Entrada = codigo de operacion en la instruccion:
        OpCode   : in  std_logic_vector (6 downto 0);
        -- Seniales para el PC
        Branch   : out  std_logic;                     -- 1 = Ejecutandose instruccion branch
        Ins_Jal  : out  std_logic;                     -- 1 = jal , 0 = otra instruccion, 
        Ins_Jalr : out  std_logic;                     -- 1 = jalr, 0 = otra instruccion, 
        -- Seniales relativas a la memoria y seleccion dato escritura registros
        ResultSrc: out  std_logic_vector(1 downto 0);  -- 00 salida Alu; 01 = salida de la mem.; 10 PC_plus4
        MemWrite : out  std_logic;                     -- Escribir la memoria
        MemRead  : out  std_logic;                     -- Leer la memoria
        -- Seniales para la ALU
        ALUSrc   : out  std_logic;                     -- 0 = oper.B es registro, 1 = es valor imm.
        AuiPc    : out  std_logic;                     -- 1 = AuiPC (use PC in add), 0 = reg1.
        ALUOp    : out  std_logic_vector (2 downto 0); -- Tipo operacion para control de la ALU
        -- Seniales para el GPR
        RegWrite : out  std_logic                      -- 1 = Escribir registro
     );
  end component;

  component alu_control is
    port (
      -- Entradas:
      ALUOp  : in std_logic_vector (2 downto 0);     -- Codigo de control desde la unidad de control
      Funct3 : in std_logic_vector (2 downto 0);     -- Campo "funct3" de la instruccion (I(14:12))
      Funct7 : in std_logic_vector (6 downto 0);     -- Campo "funct7" de la instruccion (I(31:25))     
      -- Salida de control para la ALU:
      ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
    );
  end component alu_control;

  component Imm_Gen is
    port (
        instr     : in std_logic_vector(31 downto 0);
        imm       : out std_logic_vector(31 downto 0)
    );
  end component Imm_Gen;

  component Hazard_unit is
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
      -- Salidas Evitar Load USE
      stall_pipe  : out std_logic                      -- para el pipeline en IF and ID
   );
  end component Hazard_unit;

    
end package RISCV_pack;

package body RISCV_pack is
-- declare common fnctions and procedures
end package body;