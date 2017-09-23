library verilog;
use verilog.vl_types.all;
entity Cache_Probe_if is
    port(
        rrdy            : in     vl_logic_vector(0 downto 0);
        rdrdy           : in     vl_logic_vector(0 downto 0);
        wacpt           : in     vl_logic_vector(0 downto 0);
        rrqst           : in     vl_logic_vector(0 downto 0);
        rdacpt          : in     vl_logic_vector(0 downto 0);
        wrqst           : in     vl_logic_vector(0 downto 0);
        offdata         : in     vl_logic_vector(15 downto 0);
        macc            : out    vl_logic_vector(0 downto 0);
        rd              : out    vl_logic_vector(0 downto 0);
        addr            : out    vl_logic_vector(15 downto 0);
        din             : out    vl_logic_vector(15 downto 0);
        dout            : in     vl_logic_vector(15 downto 0);
        complete        : in     vl_logic_vector(0 downto 0)
    );
end Cache_Probe_if;
