library verilog;
use verilog.vl_types.all;
entity LC3 is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        pc              : out    vl_logic_vector(15 downto 0);
        instrmem_rd     : out    vl_logic;
        Instr_dout      : in     vl_logic_vector(15 downto 0);
        Data_addr       : out    vl_logic_vector(15 downto 0);
        complete_instr  : in     vl_logic;
        complete_data   : in     vl_logic;
        Data_din        : out    vl_logic_vector(15 downto 0);
        Data_dout       : in     vl_logic_vector(15 downto 0);
        Data_rd         : out    vl_logic;
        D_macc          : out    vl_logic;
        I_macc          : out    vl_logic
    );
end LC3;
