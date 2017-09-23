library verilog;
use verilog.vl_types.all;
entity Arith_ALU is
    generic(
        reg_wd          : integer := 32
    );
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        aluin1          : in     vl_logic_vector;
        aluin2          : in     vl_logic_vector;
        aluoperation    : in     vl_logic_vector(2 downto 0);
        aluopselect     : in     vl_logic_vector(2 downto 0);
        aluout          : out    vl_logic_vector
    );
end Arith_ALU;
