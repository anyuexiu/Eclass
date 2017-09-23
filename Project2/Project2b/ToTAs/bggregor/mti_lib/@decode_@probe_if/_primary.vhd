library verilog;
use verilog.vl_types.all;
entity Decode_Probe_if is
    port(
        IR              : in     vl_logic_vector(15 downto 0);
        npc_out         : in     vl_logic_vector(15 downto 0);
        npc_in          : in     vl_logic_vector(15 downto 0);
        W_Control       : in     vl_logic_vector(1 downto 0);
        Mem_Control     : in     vl_logic_vector(0 downto 0);
        E_Control       : in     vl_logic_vector(5 downto 0);
        dout            : in     vl_logic_vector(15 downto 0);
        enable_decode   : in     vl_logic_vector(0 downto 0);
        reset           : in     vl_logic_vector(0 downto 0);
        clock           : in     vl_logic_vector(0 downto 0)
    );
end Decode_Probe_if;
