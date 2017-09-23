library verilog;
use verilog.vl_types.all;
entity ProcInterface_Probe_if is
    port(
        rd              : in     vl_logic_vector(0 downto 0);
        addr            : in     vl_logic_vector(15 downto 0);
        dout            : in     vl_logic_vector(15 downto 0);
        complete        : in     vl_logic_vector(0 downto 0);
        state           : in     vl_logic_vector(3 downto 0);
        miss            : in     vl_logic_vector(0 downto 0);
        blockdata       : in     vl_logic_vector(63 downto 0);
        data            : in     vl_logic_vector(73 downto 0)
    );
end ProcInterface_Probe_if;
