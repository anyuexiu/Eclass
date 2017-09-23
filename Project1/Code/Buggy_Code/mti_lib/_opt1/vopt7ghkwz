library verilog;
use verilog.vl_types.all;
entity Instr_Memory is
    port(
        clock           : in     vl_logic;
        addr            : in     vl_logic_vector(15 downto 0);
        din             : in     vl_logic_vector(15 downto 0);
        rd              : in     vl_logic;
        wr              : in     vl_logic;
        Instr_dout      : out    vl_logic_vector(15 downto 0);
        complete_instr  : out    vl_logic
    );
end Instr_Memory;
