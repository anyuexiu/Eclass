library verilog;
use verilog.vl_types.all;
entity DataCache is
    port(
        clock           : in     vl_logic;
        addr            : in     vl_logic_vector(15 downto 0);
        din             : in     vl_logic_vector(15 downto 0);
        rd              : in     vl_logic;
        dout            : out    vl_logic_vector(15 downto 0);
        complete        : out    vl_logic;
        rrqst           : out    vl_logic;
        rrdy            : in     vl_logic;
        rdrdy           : in     vl_logic;
        rdacpt          : out    vl_logic;
        offdata         : inout  vl_logic_vector(15 downto 0);
        wrqst           : out    vl_logic;
        wacpt           : in     vl_logic;
        reset           : in     vl_logic;
        macc            : in     vl_logic
    );
end DataCache;
