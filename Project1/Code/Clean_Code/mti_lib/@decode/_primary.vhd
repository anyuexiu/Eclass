library verilog;
use verilog.vl_types.all;
entity Decode is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable_decode   : in     vl_logic;
        dout            : in     vl_logic_vector(15 downto 0);
        E_Control       : out    vl_logic_vector(5 downto 0);
        npc_in          : in     vl_logic_vector(15 downto 0);
        Mem_Control     : out    vl_logic;
        W_Control       : out    vl_logic_vector(1 downto 0);
        IR              : out    vl_logic_vector(15 downto 0);
        npc_out         : out    vl_logic_vector(15 downto 0)
    );
end Decode;
