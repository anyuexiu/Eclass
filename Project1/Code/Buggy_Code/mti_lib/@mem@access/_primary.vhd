library verilog;
use verilog.vl_types.all;
entity MemAccess is
    port(
        mem_state       : in     vl_logic_vector(1 downto 0);
        M_Control       : in     vl_logic;
        M_Data          : in     vl_logic_vector(15 downto 0);
        M_Addr          : in     vl_logic_vector(15 downto 0);
        memout          : out    vl_logic_vector(15 downto 0);
        Data_addr       : out    vl_logic_vector(15 downto 0);
        Data_din        : out    vl_logic_vector(15 downto 0);
        Data_dout       : in     vl_logic_vector(15 downto 0);
        Data_rd         : out    vl_logic
    );
end MemAccess;
