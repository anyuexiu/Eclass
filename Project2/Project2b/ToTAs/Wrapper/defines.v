`define CLK_PERIOD 10

//Define data memory delay params
`define handshake2 30
`define mem_latency 100

//Define operation code
`define ADD 4'b0001
`define AND 4'b0101
`define NOT 4'b1001
`define BR 4'b0000
`define JMP 4'b1100
`define LD 4'b0010
`define LDR 4'b0110
`define LDI 4'b1010
`define LEA 4'b1110
`define ST 4'b0011
`define STR 4'b0111
`define STI 4'b1011

//Define testbench iterations
`define TEST_ITER 5

//Define param to randomize register file
`define RAND_REGS 1'b0 

//Define param to run until error is detected
`define AUTO_STOP 1'b1

//Define param to allow complete_instr signal to randomly be set low
`define ALLOW_COMP_INSTR 1'b0

//Define param to allow NOP instructions
`define ALLOW_NOP 1'b1

//Define param to allow checking statements
`define CHECKING_ON 1'b0

//Define param to allow console debug output
`define DEBUG_ON 1'b0

//Define param to allow coverage debug output
`define CVG_DBG_ON 1'b1

//Define param to allow cache checking statements
`define CACHE_CHECK_ON 1'b0

//Define Reg File Initialization
//`define R0_INIT 16'h0000
//`define R1_INIT 16'hffff
//`define R2_INIT 16'h8000
//`define R3_INIT 16'hc000
//`define R4_INIT 16'h4000
//`define R5_INIT 16'h0000
//`define R6_INIT 16'h0001
//`define R7_INIT 16'h0000

//`define R0_INIT 16'haaaa
//`define R1_INIT 16'h5555
//`define R2_INIT 16'h0000
//`define R3_INIT 16'hffff
//`define R4_INIT 16'h5555
//`define R5_INIT 16'h0001
//`define R6_INIT 16'h0001
//`define R7_INIT 16'haaaa

`define R0_INIT 16'h8fff
`define R1_INIT 16'hcfff
`define R2_INIT 16'h0000
`define R3_INIT 16'h4fff
`define R4_INIT 16'h5555
`define R5_INIT 16'haaaa
`define R6_INIT 16'hffff
`define R7_INIT 16'h0000

