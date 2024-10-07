--------------------------------------------------------------------------------
-- Procesador RISC V pipelined curso Arquitectura Ordenadores 2024
-- G. Sutter initial release jul2024
-- Rev. 2.1 ago2024 - Sin resulución de riesgos
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.RISCV_pack.all;

entity processorRV is
   port(
      Clk      : in  std_logic;                     -- Reloj activo en flanco subida
      Reset    : in  std_logic;                     -- Reset asincrono activo nivel alto
      -- Instruction memory
      IAddr    : out std_logic_vector(31 downto 0); -- Direccion Instr
      IDataIn  : in  std_logic_vector(31 downto 0); -- Instruccion leida
      -- Data memory
      DAddr    : out std_logic_vector(31 downto 0); -- Direccion
      DRdEn    : out std_logic;                     -- Habilitacion lectura
      DWrEn    : out std_logic;                     -- Habilitacion escritura
      DDataOut : out std_logic_vector(31 downto 0); -- Dato escrito
      DDataIn  : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processorRV;

architecture rtl of processorRV is

--component declaration moved to RISCV_pack
  -- component alu_RV
  -- component reg_bank
  -- component control_unit
  -- component alu_control
  -- component Imm_Gen
  -- component Hazard_unit
  
  -- Signals -- IF
  signal Instruct_IF    : std_logic_vector(31 downto 0); -- La instrucción desde la mem de instr
  signal PC_next        : std_logic_vector(31 downto 0);
  signal PC_reg_IF      : std_logic_vector(31 downto 0);
  signal PC_plus4_IF    : std_logic_vector(31 downto 0);   

  -- Signals -- ID
  signal Instruct_ID     : std_logic_vector(31 downto 0); -- La instrucción en ID
  signal PC_reg_ID       : std_logic_vector(31 downto 0);
  signal PC_plus4_ID     : std_logic_vector(31 downto 0); 
  signal Funct3_ID       : std_logic_vector( 2 downto 0);
  signal Funct7_ID       : std_logic_vector( 6 downto 0);
  signal RS1_ID          : std_logic_vector( 4 downto 0);
  signal RS2_ID, RD_ID   : std_logic_vector( 4 downto 0);
  signal reg_RS1_ID      : std_logic_vector(31 downto 0);
  signal reg_RS2_ID      : std_logic_vector(31 downto 0);
  signal imm_ext_ID      : std_logic_vector(31 downto 0); -- La parte baja de la instrucción extendida de signo

  signal Ctrl_ALUOp_ID   : std_logic_vector(2 downto 0);
  signal Ctrl_ResSrc_ID  : std_logic_vector(1 downto 0);
  signal Ctrl_Jal_ID, Ctrl_Jalr_ID         : std_logic;
  signal Ctrl_auiPC_ID, Ctrl_ALUSrc_ID     : std_logic;
  signal Ctrl_MemRead_ID, Ctrl_MemWrite_ID : std_logic;
  signal Ctrl_Branch_ID, Ctrl_RegWrite_ID  : std_logic;

  -- Signals -- EX
  signal Instruct_EX     : std_logic_vector(31 downto 0); -- La instrucción en EX
  signal PC_reg_EX       : std_logic_vector(31 downto 0);
  signal PC_plus4_EX     : std_logic_vector(31 downto 0); 
  signal Funct3_EX       : std_logic_vector( 2 downto 0);
  signal Funct7_EX       : std_logic_vector( 6 downto 0);
  signal RS1_EX          : std_logic_vector( 4 downto 0);
  signal RS2_EX, RD_EX   : std_logic_vector( 4 downto 0);
  signal reg_RS1_EX      : std_logic_vector(31 downto 0);
  signal reg_RS2_EX      : std_logic_vector(31 downto 0);
  signal imm_ext_EX      : std_logic_vector(31 downto 0); -- La parte baja de la instrucción en EX

  signal Ctrl_ALUOp_EX   : std_logic_vector(2 downto 0);
  signal Ctrl_ResSrc_EX  : std_logic_vector(1 downto 0);
  signal Ctrl_Jal_EX, Ctrl_Jalr_EX         : std_logic;
  signal Ctrl_auiPC_EX, Ctrl_ALUSrc_EX     : std_logic;
  signal Ctrl_MemRead_EX, Ctrl_MemWrite_EX : std_logic;
  signal Ctrl_Branch_EX, Ctrl_RegWrite_EX  : std_logic;

  signal Addr_BranchJal  : std_logic_vector(31 downto 0);
  signal Addr_Jalr       : std_logic_vector(31 downto 0);
  signal Addr_Jump_EX    : std_logic_vector(31 downto 0);

  signal Alu_Res_EX      : std_logic_vector(31 downto 0);
  signal Alu_Op1         : std_logic_vector(31 downto 0);
  signal Alu_Op2         : std_logic_vector(31 downto 0);
  signal Alu_ZERO_EX     : std_logic;
  signal Alu_SIGN_EX     : std_logic;
  signal AluControl      : std_logic_vector(3 downto 0);

  -- Signals -- MEM
  signal Addr_Jump_ME    : std_logic_vector(31 downto 0);
  signal PC_plus4_ME     : std_logic_vector(31 downto 0);
  signal Funct3_ME       : std_logic_vector( 2 downto 0);
  signal branch_true     : std_logic;  
  signal decision_Jump   : std_logic;
  signal Alu_ZERO_ME     : std_logic;
  signal Alu_SIGN_ME     : std_logic;
  signal Alu_Res_ME      : std_logic_vector(31 downto 0);
  signal reg_RS2_ME      : std_logic_vector(31 downto 0);
  signal RD_ME           : std_logic_vector( 4 downto 0);
  signal ReadData_ME     : std_logic_vector(31 downto 0); -- Dato desde memoria

  signal Ctrl_ResSrc_ME  : std_logic_vector(1 downto 0);
  signal Ctrl_Jal_ME, Ctrl_Jalr_ME         : std_logic;
  signal Ctrl_MemRead_ME, Ctrl_MemWrite_ME : std_logic;
  signal Ctrl_Branch_ME, Ctrl_RegWrite_ME  : std_logic;

  -- Signals -- WB
  signal RD_WB           : std_logic_vector( 4 downto 0); 
  signal Ctrl_RegWrite_WB: std_logic;
  signal Ctrl_ResSrc_WB  : std_logic_vector(1 downto 0);
  signal PC_plus4_WB     : std_logic_vector(31 downto 0);
  signal result_WB  : std_logic_vector(31 downto 0);
  signal ReadData_WB     : std_logic_vector(31 downto 0); -- Dato desde memoria
  signal Alu_Res_WB      : std_logic_vector(31 downto 0);

  -- Other Signals for hazard control
  signal flush           : std_logic := '0';
  signal stall           : std_logic := '0';  
  -- signal reg_RS1_FW      : std_logic_vector(31 downto 0);
  -- signal reg_RS2_FW      : std_logic_vector(31 downto 0);
  -- signal ForwardA        : std_logic_vector (1 downto 0);  -- Adelantamiento operando 1
  -- signal ForwardB        : std_logic_vector (1 downto 0);  -- Adelantamiento operando 2

begin

-------------------------------------------
-- NO Hazard detection unit


-------------------------------------------
----** Etapa IF instraction Fetching **----
  PC_next <= Addr_Jump_ME when decision_Jump = '1' else PC_plus4_IF;

  -- Program Counter
  PC_reg_proc: process(Clk, Reset, stall)
  begin
    if Reset = '1' then
      PC_reg_IF <= (22 => '1', others => '0'); -- 0040_0000
    elsif rising_edge(Clk) then
      if (stall = '0') then
        PC_reg_IF <= PC_next;
      end if;
    end if;
  end process;

  PC_plus4_IF <= PC_reg_IF + 4;
  IAddr       <= PC_reg_IF;
  Instruct_IF <= IDataIn;

-----------------------------------------
----** Etapa ID instraction decode **----
  IF_ID_reg: process(Clk, Reset, flush, stall)
  begin
    if Reset = '1' then
      instruct_ID    <= (others => '0');
      PC_reg_ID      <= (others => '0');
      PC_plus4_ID    <= (others => '0');
    elsif (rising_edge(Clk)) then
      if (flush = '1') then
        instruct_ID    <= (others => '0');
        PC_reg_ID      <= (others => '0');
        PC_plus4_ID    <= (others => '0');
      elsif (stall = '0') then
        instruct_ID    <= instruct_IF;
        PC_reg_ID      <= PC_reg_IF;
        PC_plus4_ID    <= PC_plus4_IF;
      end if;
    end if;
  end process;

  Funct3_ID   <= instruct_ID(14 downto 12); -- Campo "funct3" de la instruccion
  Funct7_ID   <= instruct_ID(31 downto 25); -- Campo "funct7" de la instruccion
  RD_ID       <= Instruct_ID(11 downto  7);
  RS1_ID      <= Instruct_ID(19 downto 15);
  RS2_ID      <= Instruct_ID(24 downto 20);  

  RegsRISCV : reg_bank
  port map (
    Clk   => Clk,
    Reset => Reset,
    A1    => RS1_ID, --Instruction(19 downto 15), --rs1
    Rd1   => reg_RS1_ID,
    A2    => RS2_ID, --Instruction(24 downto 20), --rs2
    Rd2   => reg_RS2_ID,
    A3    => RD_WB,  --Instruction(11 downto 7) desde WB,
    Wd3   => result_WB,
    We3   => Ctrl_RegWrite_WB
  );

  UnidadControl : control_unit
  port map(
    OpCode   => Instruct_ID(6 downto 0),
    -- Señales para el PC (salto)
    Branch   => Ctrl_Branch_ID,
    Ins_Jal  => Ctrl_Jal_ID,
    Ins_Jalr => Ctrl_Jalr_ID,
    -- Señales para la memoria y seleccion dato escritura registros
    ResultSrc=> Ctrl_ResSrc_ID,
    MemWrite => Ctrl_MemWrite_ID,
    MemRead  => Ctrl_MemRead_ID,
    -- Señales para la ALU
    ALUSrc   => Ctrl_ALUSrc_ID,
    AuiPc    => Ctrl_auiPc_ID,
    ALUOp    => Ctrl_ALUOp_ID,
    -- Señales para el GPR
    RegWrite => Ctrl_RegWrite_ID
  );

  immed_op : Imm_Gen
  port map (
        instr    => Instruct_ID,
        imm      => Imm_ext_ID 
  );

-----------------------------------------
----** Etapa EX - Execution in ALU **----
  ID_EX_reg: process(Clk, Reset, flush)
  begin
    if Reset = '1' then
      reg_RS1_EX  <= (others => '0');
      reg_RS2_EX  <= (others => '0');
      PC_reg_EX   <= (others => '0');
      PC_plus4_EX <= (others => '0');
      Funct3_EX   <= (others => '0');
      Funct7_EX   <= (others => '0');
      RD_EX       <= (others => '0');
      RS1_EX      <= (others => '0');
      RS2_EX      <= (others => '0');
      imm_ext_EX  <= (others => '0');

      Ctrl_ALUSrc_EX    <= '0'; 
      Ctrl_Jalr_EX      <= '0';
      Ctrl_Jal_EX       <= '0';
      Ctrl_Branch_EX    <= '0';
      Ctrl_MemWrite_EX  <= '0';
      Ctrl_MemRead_EX   <= '0';
      Ctrl_RegWrite_EX  <= '0';
      Ctrl_auiPc_EX     <= '0';
      Ctrl_ALUOP_EX     <= (others => '0');
      Ctrl_ResSrc_EX    <= (others => '0');
    elsif rising_edge(Clk) then
      if (flush = '1' or stall = '1') then -- El stall en IF e ID, en EX es reset es decir NOP
        Ctrl_ALUSrc_EX    <= '0';          -- Solo con "limpiar" la señales de control es suficiente
        Ctrl_Jalr_EX      <= '0';
        Ctrl_Jal_EX       <= '0';
        Ctrl_Branch_EX    <= '0';
        Ctrl_MemWrite_EX  <= '0';
        Ctrl_MemRead_EX   <= '0';
        Ctrl_RegWrite_EX  <= '0';
        Ctrl_auiPc_EX     <= '0';
        Ctrl_ALUOP_EX     <= (others => '0');
        Ctrl_ResSrc_EX    <= (others => '0');
      else --// no flush
        reg_RS1_EX       <= reg_RS1_ID;
        reg_RS2_EX       <= reg_RS2_ID;
        PC_reg_EX        <= PC_reg_ID;
        PC_plus4_EX      <= PC_plus4_ID;
        imm_ext_EX       <= imm_ext_ID;
        Funct3_EX        <= Funct3_ID;
        Funct7_EX        <= Funct7_ID;
        RD_EX            <= RD_ID;
        RS1_EX           <= RS1_ID;
        RS2_EX           <= RS2_ID;

        Ctrl_ALUSrc_EX    <= Ctrl_ALUSrc_ID; 
        Ctrl_Jalr_EX      <= Ctrl_Jalr_ID;     
        Ctrl_Jal_EX       <= Ctrl_Jal_ID;      
        Ctrl_Branch_EX    <= Ctrl_Branch_ID;   
        Ctrl_MemWrite_EX  <= Ctrl_MemWrite_ID; 
        Ctrl_MemRead_EX   <= Ctrl_MemRead_ID;  
        Ctrl_RegWrite_EX  <= Ctrl_RegWrite_ID; 
        Ctrl_ALUOP_EX     <= Ctrl_ALUOP_ID;    
        Ctrl_ResSrc_EX    <= Ctrl_ResSrc_ID;   
        Ctrl_auiPc_EX     <= Ctrl_auiPc_ID;    
      end if;
    end if;
  end process;

  Addr_BranchJal <= PC_reg_EX  + Imm_ext_EX;
  Addr_Jalr      <= reg_RS1_EX + Imm_ext_EX;
  Addr_Jump_EX   <= Addr_Jalr when Ctrl_Jalr_EX = '1' else Addr_BranchJal;

  Alu_control_i: alu_control
  port map(
    -- Entradas:
    ALUOp   => Ctrl_ALUOp_EX, -- Codigo de control desde la unidad de control
    Funct3  => Funct3_EX,    -- Campo "funct3" de la instruccion
    Funct7  => Funct7_EX,    -- Campo "funct7" de la instruccion
    -- Salida de control para la ALU:
    ALUControl => AluControl -- Define operacion a ejecutar por la ALU
  );

  -- Aquí los Multiplexores de Adelantamiento de datos

  Alu_Op1    <= reg_RS1_EX when Ctrl_auiPc_EX  = '0' else PC_reg_EX;
  Alu_Op2    <= reg_RS2_EX when Ctrl_ALUSrc_EX = '0' else Imm_ext_EX;

  Alu_RISCV : alu_RV
  port map (
    OpA      => Alu_Op1,
    OpB      => Alu_Op2,
    Control  => AluControl,
    Result   => Alu_Res_EX,
    Signflag => Alu_SIGN_EX,
    CarryOut => open,
    Zflag    => Alu_ZERO_EX
  );


----------------------------------------------------
----** Etapa MEM data memory access adn Jump **----

  EX_MEM_reg: process(Clk, Reset, flush)
  begin
    if Reset = '1' then
      Addr_Jump_ME        <= (others => '0');
      PC_plus4_ME         <= (others => '0');
      RD_ME               <= (others => '0');
      reg_RS2_ME          <= (others => '0');
      Alu_Res_ME          <= (others => '0');
      Funct3_ME           <= (others => '0');
      Alu_ZERO_ME         <= '0'; 
      Alu_SIGN_ME         <= '0'; 

      Ctrl_Jalr_ME        <= '0';
      Ctrl_Jal_ME         <= '0';
      Ctrl_Branch_ME      <= '0';
      Ctrl_MemWrite_ME    <= '0';
      Ctrl_MemRead_ME     <= '0';
      Ctrl_RegWrite_ME    <= '0';
      Ctrl_ResSrc_ME      <= (others => '0');

    elsif rising_edge(Clk) then
      if (flush = '1') then -- Solo con "limpiar" la señales de control es suficiente
        Ctrl_Jalr_ME        <= '0';
        Ctrl_Jal_ME         <= '0';
        Ctrl_Branch_ME      <= '0';
        Ctrl_MemWrite_ME    <= '0';
        Ctrl_MemRead_ME     <= '0';
        Ctrl_RegWrite_ME    <= '0';
        Ctrl_ResSrc_ME      <= (others => '0');
      else
        Addr_Jump_ME        <= Addr_Jump_EX;
        PC_plus4_ME         <= PC_plus4_EX;
        RD_ME               <= RD_EX;
        reg_RS2_ME          <= reg_RS2_EX;
        Alu_Res_ME          <= Alu_Res_EX;
        Funct3_ME           <= Funct3_EX;
        Alu_ZERO_ME         <= Alu_ZERO_EX;
        Alu_SIGN_ME         <= Alu_SIGN_EX;

        Ctrl_RegWrite_ME <= Ctrl_RegWrite_EX;
        Ctrl_MemRead_ME  <= Ctrl_MemRead_EX;
        Ctrl_MemWrite_ME <= Ctrl_MemWrite_EX;
        Ctrl_Branch_ME   <= Ctrl_Branch_EX;
        Ctrl_Jalr_ME     <= Ctrl_Jalr_EX;
        Ctrl_Jal_ME      <= Ctrl_Jal_EX;
        Ctrl_ResSrc_ME   <= Ctrl_ResSrc_EX;

      end if;

    end if;
  end process;

  -- Jump Logic: decide si saltar o sino usa PC+4
  decision_Jump  <= Ctrl_Jal_ME or Ctrl_Jalr_ME or (Ctrl_Branch_ME and branch_true);
  branch_true    <= '1' when ( ((Funct3_ME = BR_F3_BEQ) and (Alu_ZERO_ME = '1')) or
                               ((Funct3_ME = BR_F3_BNE) and (Alu_ZERO_ME = '0')) or
                               ((Funct3_ME = BR_F3_BLT) and (Alu_SIGN_ME = '1')) or
                               ((Funct3_ME = BR_F3_BGE) and (Alu_SIGN_ME = '0')) ) else
                    '0';

  -- Salidas hacia Memoria de datos                  
  DAddr          <= Alu_Res_ME;
  DDataOut       <= reg_RS2_ME;
  DWrEn          <= Ctrl_MemWrite_ME;
  DRdEn          <= Ctrl_MemRead_ME;
  ReadData_ME    <= DDataIn;

------------------------------------------------
----** Etapa WB write Back. Escritura reg **----  

  MEM_WB_reg: process(Clk, Reset)
  begin
    if Reset = '1' then
      PC_plus4_WB       <= (others => '0');
      RD_WB             <= (others => '0');
      ReadData_WB       <= (others => '0');
      Alu_Res_WB        <= (others => '0');
      Ctrl_RegWrite_WB  <= '0';
      Ctrl_ResSrc_WB    <= (others => '0');
    elsif rising_edge(Clk) then
      PC_plus4_WB      <= PC_plus4_ME;
      RD_WB            <= RD_ME;
      Alu_Res_WB       <= Alu_Res_ME;
      ReadData_WB      <= ReadData_ME;
      Ctrl_RegWrite_WB <= Ctrl_RegWrite_ME;
      Ctrl_ResSrc_WB   <= Ctrl_ResSrc_ME;
    end if;
  end process;

  -- Multiplexor Final.
  result_WB   <= ReadData_WB   when Ctrl_ResSrc_WB = "01" else -- Res desde Memoria
                 PC_plus4_WB   when Ctrl_ResSrc_WB = "10" else -- Res es PC+4
                 Alu_Res_WB;   -- When 00 -- result desde ALU

end architecture;
