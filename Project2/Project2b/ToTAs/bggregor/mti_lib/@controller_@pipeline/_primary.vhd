library verilog;
use verilog.vl_types.all;
entity Controller_Pipeline is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        IR              : in     vl_logic_vector(15 downto 0);
        bypass_alu_1    : out    vl_logic;
        bypass_alu_2    : out    vl_logic;
        bypass_mem_1    : out    vl_logic;
        bypass_mem_2    : out    vl_logic;
        complete_data   : in     vl_logic;
        complete_instr  : in     vl_logic;
        Instr_dout      : in     vl_logic_vector(15 downto 0);
        NZP             : in     vl_logic_vector(2 downto 0);
        psr             : in     vl_logic_vector(2 downto 0);
        IR_Exec         : in     vl_logic_vector(15 downto 0);
        enable_fetch    : out    vl_logic;
        enable_decode   : out    vl_logic;
        enable_execute  : out    vl_logic;
        enable_writeback: out    vl_logic;
        enable_updatePC : out    vl_logic;
        br_taken        : out    vl_logic;
        mem_state       : out    vl_logic_vector(1 downto 0);
        D_macc          : out    vl_logic
    );
end Controller_Pipeline;
