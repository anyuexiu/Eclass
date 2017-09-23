library verilog;
use verilog.vl_types.all;
entity Writeback is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable_writeback: in     vl_logic;
        W_Control       : in     vl_logic_vector(1 downto 0);
        aluout          : in     vl_logic_vector(15 downto 0);
        memout          : in     vl_logic_vector(15 downto 0);
        pcout           : in     vl_logic_vector(15 downto 0);
        npc             : in     vl_logic_vector(15 downto 0);
        sr1             : in     vl_logic_vector(2 downto 0);
        sr2             : in     vl_logic_vector(2 downto 0);
        dr              : in     vl_logic_vector(2 downto 0);
        d1              : out    vl_logic_vector(15 downto 0);
        d2              : out    vl_logic_vector(15 downto 0);
        psr             : out    vl_logic_vector(2 downto 0)
    );
end Writeback;
