library verilog;
use verilog.vl_types.all;
entity TA_Probe_io is
    port(
        enable_updatePC_in: in     vl_logic;
        enable_fetch_in : in     vl_logic;
        taddr_in        : in     vl_logic_vector(15 downto 0);
        br_taken_in     : in     vl_logic;
        pc2cmp          : in     vl_logic_vector(15 downto 0);
        npc2cmp         : in     vl_logic_vector(15 downto 0);
        IMem_rd2cmp     : in     vl_logic;
        IMem_dout_in    : in     vl_logic_vector(15 downto 0);
        npc_in_in       : in     vl_logic_vector(15 downto 0);
        enable_decode_in: in     vl_logic;
        IR2cmp          : in     vl_logic_vector(15 downto 0);
        npc_out2cmp     : in     vl_logic_vector(15 downto 0);
        E_control2cmp   : in     vl_logic_vector(5 downto 0);
        W_control2cmp   : in     vl_logic_vector(1 downto 0);
        Mem_control2cmp : in     vl_logic;
        enable_execute_in: in     vl_logic;
        E_control_in    : in     vl_logic_vector(5 downto 0);
        bypass_alu_1_in : in     vl_logic;
        bypass_alu_2_in : in     vl_logic;
        bypass_mem_1_in : in     vl_logic;
        bypass_mem_2_in : in     vl_logic;
        IR_in           : in     vl_logic_vector(15 downto 0);
        ex_npc_in       : in     vl_logic_vector(15 downto 0);
        Mem_control_in  : in     vl_logic;
        VSR1_in         : in     vl_logic_vector(15 downto 0);
        VSR2_in         : in     vl_logic_vector(15 downto 0);
        mem_bypass_in   : in     vl_logic_vector(15 downto 0);
        aluout_prev_in  : in     vl_logic_vector(15 downto 0);
        W_Control_out2cmp: in     vl_logic_vector(1 downto 0);
        Mem_Control_out2cmp: in     vl_logic;
        aluout2cmp      : in     vl_logic_vector(15 downto 0);
        dr2cmp          : in     vl_logic_vector(2 downto 0);
        sr12cmp         : in     vl_logic_vector(2 downto 0);
        sr22cmp         : in     vl_logic_vector(2 downto 0);
        NZP2cmp         : in     vl_logic_vector(2 downto 0);
        IR_Exec2cmp     : in     vl_logic_vector(15 downto 0);
        M_Data2cmp      : in     vl_logic_vector(15 downto 0);
        imm52cmp        : in     vl_logic_vector(15 downto 0);
        offset62cmp     : in     vl_logic_vector(15 downto 0);
        offset92cmp     : in     vl_logic_vector(15 downto 0);
        offset112cmp    : in     vl_logic_vector(15 downto 0);
        enable_wb_in    : in     vl_logic;
        W_Control_wb_in : in     vl_logic_vector(1 downto 0);
        pcout_wb_in     : in     vl_logic_vector(15 downto 0);
        memout_wb_in    : in     vl_logic_vector(15 downto 0);
        dr_wb_in        : in     vl_logic_vector(2 downto 0);
        sr1_wb_in       : in     vl_logic_vector(2 downto 0);
        sr2_wb_in       : in     vl_logic_vector(2 downto 0);
        npc_wb_in       : in     vl_logic_vector(15 downto 0);
        aluout_wb_in    : in     vl_logic_vector(15 downto 0);
        ram_wb_in       : in     vl_logic_vector(0 to 7);
        VSR12cmp        : in     vl_logic_vector(15 downto 0);
        VSR22cmp        : in     vl_logic_vector(15 downto 0);
        psr2cmp         : in     vl_logic_vector(2 downto 0);
        complete_data_in: in     vl_logic;
        complete_instr_in: in     vl_logic;
        IR_ctrl_in      : in     vl_logic_vector(15 downto 0);
        IR_Exec_in      : in     vl_logic_vector(15 downto 0);
        NZP_in          : in     vl_logic_vector(2 downto 0);
        psr_in          : in     vl_logic_vector(2 downto 0);
        enable_updatePC2cmp: in     vl_logic;
        enable_fetch2cmp: in     vl_logic;
        enable_decode2cmp: in     vl_logic;
        enable_execute2cmp: in     vl_logic;
        enable_writeback2cmp: in     vl_logic;
        bypass_alu_12cmp: in     vl_logic;
        bypass_alu_22cmp: in     vl_logic;
        bypass_mem_12cmp: in     vl_logic;
        bypass_mem_22cmp: in     vl_logic;
        mem_state2cmp   : in     vl_logic_vector(1 downto 0);
        br_taken2cmp    : in     vl_logic;
        mem_state_in    : in     vl_logic_vector(1 downto 0);
        M_control_in    : in     vl_logic;
        M_Data_in       : in     vl_logic_vector(15 downto 0);
        M_Addr_in       : in     vl_logic_vector(15 downto 0);
        Data_dout_in    : in     vl_logic_vector(15 downto 0);
        Data_addr2cmp   : in     vl_logic_vector(15 downto 0);
        Data_din2cmp    : in     vl_logic_vector(15 downto 0);
        Data_rd2cmp     : in     vl_logic;
        memout2cmp      : in     vl_logic_vector(15 downto 0)
    );
end TA_Probe_io;