library verilog;
use verilog.vl_types.all;
entity ValidArray_Probe_if is
    port(
        reset           : in     vl_logic_vector(0 downto 0);
        index           : in     vl_logic_vector(3 downto 0);
        state           : in     vl_logic_vector(3 downto 0);
        valid           : in     vl_logic_vector(0 downto 0);
        validarr        : in     vl_logic_vector(15 downto 0)
    );
end ValidArray_Probe_if;
