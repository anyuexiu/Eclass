library verilog;
use verilog.vl_types.all;
entity LC3_Cache is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        pc              : out    vl_logic_vector(15 downto 0);
        instrmem_rd     : out    vl_logic;
        Instr_dout      : in     vl_logic_vector(15 downto 0);
        complete_instr  : in     vl_logic
    );
end LC3_Cache;
