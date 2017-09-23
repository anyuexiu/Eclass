library verilog;
use verilog.vl_types.all;
entity Execute is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        E_Control       : in     vl_logic_vector(5 downto 0);
        IR              : in     vl_logic_vector(15 downto 0);
        npc             : in     vl_logic_vector(15 downto 0);
        W_Control_in    : in     vl_logic_vector(1 downto 0);
        Mem_Control_in  : in     vl_logic;
        VSR1            : in     vl_logic_vector(15 downto 0);
        VSR2            : in     vl_logic_vector(15 downto 0);
        enable_execute  : in     vl_logic;
        W_Control_out   : out    vl_logic_vector(1 downto 0);
        Mem_Control_out : out    vl_logic;
        NZP             : out    vl_logic_vector(2 downto 0);
        aluout          : out    vl_logic_vector(15 downto 0);
        pcout           : out    vl_logic_vector(15 downto 0);
        sr1             : out    vl_logic_vector(2 downto 0);
        sr2             : out    vl_logic_vector(2 downto 0);
        dr              : out    vl_logic_vector(2 downto 0);
        M_Data          : out    vl_logic_vector(15 downto 0)
    );
end Execute;
