library verilog;
use verilog.vl_types.all;
entity CacheController_Probe_if is
    port(
        reset           : in     vl_logic_vector(0 downto 0);
        macc            : in     vl_logic_vector(0 downto 0);
        miss            : in     vl_logic_vector(0 downto 0);
        rd              : in     vl_logic_vector(0 downto 0);
        state           : in     vl_logic_vector(3 downto 0);
        count           : in     vl_logic_vector(1 downto 0);
        rrdy            : in     vl_logic_vector(0 downto 0);
        rdrdy           : in     vl_logic_vector(0 downto 0);
        wacpt           : in     vl_logic_vector(0 downto 0)
    );
end CacheController_Probe_if;
