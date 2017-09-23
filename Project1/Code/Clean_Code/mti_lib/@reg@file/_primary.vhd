library verilog;
use verilog.vl_types.all;
entity RegFile is
    port(
        clock           : in     vl_logic;
        wr              : in     vl_logic;
        sr1             : in     vl_logic_vector(2 downto 0);
        sr2             : in     vl_logic_vector(2 downto 0);
        din             : in     vl_logic_vector(15 downto 0);
        dr              : in     vl_logic_vector(2 downto 0);
        d1              : out    vl_logic_vector(15 downto 0);
        d2              : out    vl_logic_vector(15 downto 0)
    );
end RegFile;
