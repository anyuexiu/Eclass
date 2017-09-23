library verilog;
use verilog.vl_types.all;
entity Shift_ALU is
    generic(
        reg_wd          : integer := 32
    );
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        \in\            : in     vl_logic_vector;
        shift           : in     vl_logic_vector(4 downto 0);
        shift_operation : in     vl_logic_vector(2 downto 0);
        aluout          : out    vl_logic_vector
    );
end Shift_ALU;
