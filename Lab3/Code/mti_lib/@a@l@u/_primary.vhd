library verilog;
use verilog.vl_types.all;
entity ALU is
    generic(
        instr_wd        : integer := 32;
        reg_wd          : integer := 32;
        imm_wd          : integer := 16
    );
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        aluin1          : in     vl_logic_vector;
        aluin2          : in     vl_logic_vector;
        opselect        : in     vl_logic_vector(2 downto 0);
        operation       : in     vl_logic_vector(2 downto 0);
        enable_arith    : in     vl_logic;
        enable_shift    : in     vl_logic;
        shift_number    : in     vl_logic_vector(4 downto 0);
        aluout          : out    vl_logic_vector;
        carry           : out    vl_logic
    );
end ALU;
