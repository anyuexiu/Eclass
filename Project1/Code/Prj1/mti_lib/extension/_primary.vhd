library verilog;
use verilog.vl_types.all;
entity extension is
    port(
        ir              : in     vl_logic_vector(15 downto 0);
        offset11        : out    vl_logic_vector(15 downto 0);
        offset9         : out    vl_logic_vector(15 downto 0);
        offset6         : out    vl_logic_vector(15 downto 0);
        trapvect8       : out    vl_logic_vector(15 downto 0);
        imm5            : out    vl_logic_vector(15 downto 0)
    );
end extension;
