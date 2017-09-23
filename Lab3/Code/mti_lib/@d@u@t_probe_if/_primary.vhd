library verilog;
use verilog.vl_types.all;
entity DUT_probe_if is
    port(
        clock           : in     vl_logic;
        aluin1          : in     vl_logic_vector(31 downto 0);
        aluin2          : in     vl_logic_vector(31 downto 0);
        opselect        : in     vl_logic_vector(2 downto 0);
        operation       : in     vl_logic_vector(2 downto 0);
        shift_number    : in     vl_logic_vector(4 downto 0);
        enable_shift    : in     vl_logic;
        enable_arith    : in     vl_logic
    );
end DUT_probe_if;
