library verilog;
use verilog.vl_types.all;
entity CacheData is
    port(
        clock           : in     vl_logic;
        state           : in     vl_logic_vector(3 downto 0);
        count           : in     vl_logic_vector(1 downto 0);
        valid           : in     vl_logic;
        miss            : out    vl_logic;
        rd              : in     vl_logic;
        addr            : in     vl_logic_vector(15 downto 0);
        din             : in     vl_logic_vector(15 downto 0);
        blockdata       : out    vl_logic_vector(63 downto 0);
        offdata         : in     vl_logic_vector(15 downto 0)
    );
end CacheData;
