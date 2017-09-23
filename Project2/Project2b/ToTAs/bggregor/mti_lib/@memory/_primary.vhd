library verilog;
use verilog.vl_types.all;
entity Memory is
    port(
        reset           : in     vl_logic;
        rrqst           : in     vl_logic;
        rrdy            : out    vl_logic;
        rdrdy           : out    vl_logic;
        rdacpt          : in     vl_logic;
        data            : inout  vl_logic_vector(15 downto 0);
        wrqst           : in     vl_logic;
        wacpt           : out    vl_logic
    );
end Memory;
