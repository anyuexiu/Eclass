library verilog;
use verilog.vl_types.all;
entity CacheRAM is
    port(
        data            : inout  vl_logic_vector(73 downto 0);
        addr            : in     vl_logic_vector(3 downto 0);
        rd              : in     vl_logic
    );
end CacheRAM;
