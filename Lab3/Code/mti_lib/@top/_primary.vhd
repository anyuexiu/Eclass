library verilog;
use verilog.vl_types.all;
entity Top is
    generic(
        instr_wd        : integer := 32;
        reg_wd          : integer := 32;
        imm_wd          : integer := 16
    );
    port(
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        enable_ex       : in     vl_logic;
        src1            : in     vl_logic_vector;
        src2            : in     vl_logic_vector;
        imm             : in     vl_logic_vector;
        control_in      : in     vl_logic_vector(6 downto 0);
        mem_data_read_in: in     vl_logic_vector;
        mem_data_write_out: out    vl_logic_vector;
        mem_write_en    : out    vl_logic;
        aluout          : out    vl_logic_vector;
        carry           : out    vl_logic
    );
end Top;
