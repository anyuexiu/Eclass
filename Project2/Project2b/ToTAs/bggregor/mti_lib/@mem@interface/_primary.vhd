library verilog;
use verilog.vl_types.all;
entity MemInterface is
    port(
        state           : in     vl_logic_vector(3 downto 0);
        addr            : in     vl_logic_vector(15 downto 0);
        din             : in     vl_logic_vector(15 downto 0);
        offdata         : out    vl_logic_vector(15 downto 0);
        miss            : in     vl_logic;
        rrqst           : out    vl_logic;
        rdacpt          : out    vl_logic;
        wrqst           : out    vl_logic
    );
end MemInterface;
