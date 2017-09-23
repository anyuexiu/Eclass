library verilog;
use verilog.vl_types.all;
entity MemInterface_Probe_if is
    port(
        state           : in     vl_logic_vector(3 downto 0);
        addr            : in     vl_logic_vector(15 downto 0);
        din             : in     vl_logic_vector(15 downto 0);
        miss            : in     vl_logic_vector(0 downto 0);
        offdata         : in     vl_logic_vector(15 downto 0);
        wrqst           : in     vl_logic_vector(0 downto 0);
        rdacpt          : in     vl_logic_vector(0 downto 0);
        rrqst           : in     vl_logic_vector(0 downto 0)
    );
end MemInterface_Probe_if;
