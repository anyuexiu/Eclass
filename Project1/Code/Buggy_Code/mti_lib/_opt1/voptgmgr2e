library verilog;
use verilog.vl_types.all;
entity Controller_Pipeline is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        IR              : in     vl_logic_vector(15 downto 0);
        complete_instr  : in     vl_logic;
        complete_data   : in     vl_logic;
        psr             : in     vl_logic_vector(2 downto 0);
        NZP             : in     vl_logic_vector(2 downto 0);
        enable_fetch    : out    vl_logic;
        enable_decode   : out    vl_logic;
        enable_execute  : out    vl_logic;
        enable_writeback: out    vl_logic;
        br_taken        : out    vl_logic;
        enable_updatePC : out    vl_logic;
        mem_state       : out    vl_logic_vector(1 downto 0)
    );
end Controller_Pipeline;
