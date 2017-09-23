library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        aluin1          : in     vl_logic_vector(15 downto 0);
        aluin2          : in     vl_logic_vector(15 downto 0);
        alu_control     : in     vl_logic_vector(1 downto 0);
        enable_execute  : in     vl_logic;
        aluout          : out    vl_logic_vector(15 downto 0);
        alucarry        : out    vl_logic
    );
end ALU;
