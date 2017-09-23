library verilog;
use verilog.vl_types.all;
entity Data_Memory is
    port(
        clock           : in     vl_logic;
        addr            : in     vl_logic_vector(15 downto 0);
        din             : in     vl_logic_vector(15 downto 0);
        rd              : in     vl_logic;
        Data_dout       : out    vl_logic_vector(15 downto 0);
        complete_data   : out    vl_logic
    );
end Data_Memory;
