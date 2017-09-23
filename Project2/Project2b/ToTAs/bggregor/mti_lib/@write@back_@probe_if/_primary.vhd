library verilog;
use verilog.vl_types.all;
entity WriteBack_Probe_if is
    port(
        d1              : in     vl_logic_vector(15 downto 0);
        d2              : in     vl_logic_vector(15 downto 0);
        psr             : in     vl_logic_vector(2 downto 0);
        pcout           : in     vl_logic_vector(15 downto 0);
        memout          : in     vl_logic_vector(15 downto 0);
        aluout          : in     vl_logic_vector(15 downto 0);
        R0              : in     vl_logic_vector(15 downto 0);
        R1              : in     vl_logic_vector(15 downto 0);
        R2              : in     vl_logic_vector(15 downto 0);
        R3              : in     vl_logic_vector(15 downto 0);
        R4              : in     vl_logic_vector(15 downto 0);
        R5              : in     vl_logic_vector(15 downto 0);
        R6              : in     vl_logic_vector(15 downto 0);
        R7              : in     vl_logic_vector(15 downto 0);
        W_control_out   : in     vl_logic_vector(1 downto 0);
        enable_writeback: in     vl_logic_vector(0 downto 0);
        npc             : in     vl_logic_vector(15 downto 0);
        dr              : in     vl_logic_vector(2 downto 0);
        sr1             : in     vl_logic_vector(2 downto 0);
        sr2             : in     vl_logic_vector(2 downto 0);
        reset           : in     vl_logic_vector(0 downto 0);
        DR_in           : in     vl_logic_vector(15 downto 0)
    );
end WriteBack_Probe_if;
