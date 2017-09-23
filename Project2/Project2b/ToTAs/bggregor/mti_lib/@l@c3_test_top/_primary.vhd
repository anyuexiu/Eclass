library verilog;
use verilog.vl_types.all;
entity LC3_test_top is
    generic(
        simulation_cycle: integer := 10;
        reg_wd          : integer := 16
    );
end LC3_test_top;
