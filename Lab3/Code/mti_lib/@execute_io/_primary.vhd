library verilog;
use verilog.vl_types.all;
entity Execute_io is
    generic(
        instr_wd        : integer := 32;
        reg_wd          : integer := 32;
        imm_wd          : integer := 16
    );
    port(
        clock           : in     vl_logic
    );
end Execute_io;
