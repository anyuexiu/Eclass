library verilog;
use verilog.vl_types.all;
entity MemAccess_Probe_if is
    port(
        mem_state       : in     vl_logic_vector(1 downto 0);
        M_Control       : in     vl_logic_vector(0 downto 0);
        M_Data          : in     vl_logic_vector(15 downto 0);
        M_Addr          : in     vl_logic_vector(15 downto 0);
        Data_dout       : in     vl_logic_vector(15 downto 0);
        Data_addr       : in     vl_logic_vector(15 downto 0);
        Data_rd         : in     vl_logic_vector(0 downto 0);
        Data_din        : in     vl_logic_vector(15 downto 0);
        memout          : in     vl_logic_vector(15 downto 0)
    );
end MemAccess_Probe_if;
