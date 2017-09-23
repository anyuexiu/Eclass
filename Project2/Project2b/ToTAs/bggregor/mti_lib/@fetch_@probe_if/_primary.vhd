library verilog;
use verilog.vl_types.all;
entity Fetch_Probe_if is
    port(
        pc              : in     vl_logic_vector(15 downto 0);
        npc_out         : in     vl_logic_vector(15 downto 0);
        instrmem_rd     : in     vl_logic_vector(0 downto 0);
        enable_updatePC : in     vl_logic_vector(0 downto 0);
        taddr           : in     vl_logic_vector(15 downto 0);
        br_taken        : in     vl_logic_vector(0 downto 0);
        enable_fetch    : in     vl_logic_vector(0 downto 0);
        reset           : in     vl_logic_vector(0 downto 0)
    );
end Fetch_Probe_if;
