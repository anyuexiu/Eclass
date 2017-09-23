library verilog;
use verilog.vl_types.all;
entity CacheController is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        state           : out    vl_logic_vector(3 downto 0);
        count           : out    vl_logic_vector(1 downto 0);
        miss            : in     vl_logic;
        rd              : in     vl_logic;
        macc            : in     vl_logic;
        rrdy            : in     vl_logic;
        rdrdy           : in     vl_logic;
        wacpt           : in     vl_logic
    );
end CacheController;
