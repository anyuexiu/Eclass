library verilog;
use verilog.vl_types.all;
entity Execute_Probe_if is
    port(
        W_control_out   : in     vl_logic_vector(1 downto 0);
        Mem_control_out : in     vl_logic_vector(0 downto 0);
        W_control_in    : in     vl_logic_vector(1 downto 0);
        Mem_control_in  : in     vl_logic_vector(0 downto 0);
        aluout          : in     vl_logic_vector(15 downto 0);
        M_Data          : in     vl_logic_vector(15 downto 0);
        dr              : in     vl_logic_vector(2 downto 0);
        sr1             : in     vl_logic_vector(2 downto 0);
        sr2             : in     vl_logic_vector(2 downto 0);
        Mem_Bypass_Val  : in     vl_logic_vector(15 downto 0);
        E_Control       : in     vl_logic_vector(5 downto 0);
        IR              : in     vl_logic_vector(15 downto 0);
        VSR1            : in     vl_logic_vector(15 downto 0);
        VSR2            : in     vl_logic_vector(15 downto 0);
        bypass_alu_1    : in     vl_logic_vector(0 downto 0);
        bypass_alu_2    : in     vl_logic_vector(0 downto 0);
        bypass_mem_1    : in     vl_logic_vector(0 downto 0);
        bypass_mem_2    : in     vl_logic_vector(0 downto 0);
        enable_execute  : in     vl_logic_vector(0 downto 0);
        npc_in          : in     vl_logic_vector(15 downto 0);
        reset           : in     vl_logic_vector(0 downto 0);
        IR_Exec         : in     vl_logic_vector(15 downto 0);
        NZP             : in     vl_logic_vector(2 downto 0);
        aluin1          : in     vl_logic_vector(15 downto 0);
        aluin2          : in     vl_logic_vector(15 downto 0)
    );
end Execute_Probe_if;
