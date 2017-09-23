library verilog;
use verilog.vl_types.all;
entity Fetch is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable_updatePC : in     vl_logic;
        enable_fetch    : in     vl_logic;
        pc              : out    vl_logic_vector(15 downto 0);
        npc_out         : out    vl_logic_vector(15 downto 0);
        instrmem_rd     : out    vl_logic;
        taddr           : in     vl_logic_vector(15 downto 0);
        br_taken        : in     vl_logic
    );
end Fetch;
