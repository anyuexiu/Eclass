library verilog;
use verilog.vl_types.all;
entity ProcInterface_Data is
    port(
        clock           : in     vl_logic;
        rd              : in     vl_logic;
        addr            : in     vl_logic_vector(15 downto 0);
        dout            : out    vl_logic_vector(15 downto 0);
        complete        : out    vl_logic;
        state           : in     vl_logic_vector(3 downto 0);
        miss            : in     vl_logic;
        blockdata       : in     vl_logic_vector(63 downto 0)
    );
end ProcInterface_Data;
