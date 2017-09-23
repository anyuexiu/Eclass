library verilog;
use verilog.vl_types.all;
entity ValidArray is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        valid           : out    vl_logic;
        index           : in     vl_logic_vector(3 downto 0);
        state           : in     vl_logic_vector(3 downto 0)
    );
end ValidArray;
