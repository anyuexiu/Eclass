library verilog;
use verilog.vl_types.all;
entity Control_Probe_if is
    port(
        IR              : in     vl_logic_vector(15 downto 0);
        enable_updatePC : in     vl_logic_vector(0 downto 0);
        enable_fetch    : in     vl_logic_vector(0 downto 0);
        enable_decode   : in     vl_logic_vector(0 downto 0);
        enable_execute  : in     vl_logic_vector(0 downto 0);
        enable_writeback: in     vl_logic_vector(0 downto 0);
        bypass_alu_1    : in     vl_logic_vector(0 downto 0);
        bypass_alu_2    : in     vl_logic_vector(0 downto 0);
        bypass_mem_1    : in     vl_logic_vector(0 downto 0);
        bypass_mem_2    : in     vl_logic_vector(0 downto 0);
        complete_data   : in     vl_logic_vector(0 downto 0);
        complete_instr  : in     vl_logic_vector(0 downto 0);
        mem_state       : in     vl_logic_vector(1 downto 0);
        Instr_dout      : in     vl_logic_vector(15 downto 0);
        IR_Exec         : in     vl_logic_vector(15 downto 0);
        psr             : in     vl_logic_vector(2 downto 0);
        NZP             : in     vl_logic_vector(2 downto 0);
        br_taken        : in     vl_logic_vector(0 downto 0);
        reset           : in     vl_logic_vector(0 downto 0)
    );
end Control_Probe_if;
