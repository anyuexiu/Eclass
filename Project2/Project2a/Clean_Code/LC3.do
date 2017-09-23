onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/clock
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/reset
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/complete_instr
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/Fetch/br_taken
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Fetch/taddr
add wave -noupdate -color Orange -format Literal -radix hexadecimal /Test_LC3/DUT/pc
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Fetch/npc
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Dec/npc_out
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/instrmem_rd
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Instr_dout
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/IR
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/IR_Exec
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/aluout
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/memout
add wave -noupdate -expand -group Bypasses
add wave -noupdate -group Bypasses -color Orange -format Logic /Test_LC3/DUT/bypass_alu_1
add wave -noupdate -group Bypasses -color Orange -format Logic /Test_LC3/DUT/bypass_alu_2
add wave -noupdate -group Bypasses -color Orange -format Logic /Test_LC3/DUT/bypass_mem_1
add wave -noupdate -group Bypasses -color Orange -format Logic /Test_LC3/DUT/bypass_mem_2
add wave -noupdate -height 25 -expand -group Execute
add wave -noupdate -group Execute -format Logic /Test_LC3/DUT/Ex/clock
add wave -noupdate -group Execute -format Logic /Test_LC3/DUT/Ex/reset
add wave -noupdate -group Execute -format Logic /Test_LC3/DUT/Ex/enable_execute
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/IR
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/npc
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/VSR1
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/VSR2
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/sr1
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/sr2
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/dr
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/alu/aluin1
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/alu/aluin2
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/aluout
add wave -noupdate -group Execute -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/pcout
add wave -noupdate -group MemAccess
add wave -noupdate -group MemAccess -format Literal /Test_LC3/DUT/MemAccess/mem_state
add wave -noupdate -group MemAccess -format Logic /Test_LC3/DUT/MemAccess/M_Control
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/M_Data
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/M_Addr
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/Data_dout
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/memout
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/din
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/Data_din
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/Data_addr
add wave -noupdate -group MemAccess -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/addr
add wave -noupdate -group MemAccess -format Logic /Test_LC3/DUT/MemAccess/rd
add wave -noupdate -group MemAccess -format Logic /Test_LC3/DUT/MemAccess/Data_rd
add wave -noupdate -group Enables
add wave -noupdate -group Enables -color {Steel Blue} -format Logic /Test_LC3/DUT/enable_updatePC
add wave -noupdate -group Enables -color {Steel Blue} -format Logic /Test_LC3/DUT/enable_fetch
add wave -noupdate -group Enables -color {Steel Blue} -format Logic /Test_LC3/DUT/enable_decode
add wave -noupdate -group Enables -color {Steel Blue} -format Logic /Test_LC3/DUT/enable_execute
add wave -noupdate -group Enables -color {Steel Blue} -format Logic /Test_LC3/DUT/enable_writeback
add wave -noupdate -expand -group RegFile
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R0
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R1
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R2
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R3
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R4
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R5
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R6
add wave -noupdate -group RegFile -format Literal -radix hexadecimal /Test_LC3/DUT/WB/RF/R7
add wave -noupdate -format Literal /Test_LC3/DUT/Ctrl/prev_enables
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ctrl/state
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ctrl/next_state
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ex/dr
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Ctrl/IR
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Ctrl/prev_IR
add wave -noupdate -format Logic /Test_LC3/DUT/Ctrl/deassert_enable_writeback
add wave -noupdate -group BubbleCount
add wave -noupdate -group BubbleCount -format Literal -radix unsigned /Test_LC3/DUT/Ctrl/bubble_count
add wave -noupdate -group BubbleCount -format Logic /Test_LC3/DUT/Ctrl/stall_pipe
add wave -noupdate -group BubbleCount -format Logic /Test_LC3/DUT/Ctrl/reset_counter
add wave -noupdate -group BubbleCount -format Logic /Test_LC3/DUT/Ctrl/inc_count
add wave -noupdate -group BubbleCount -format Logic /Test_LC3/DUT/Ctrl/reset_count
add wave -noupdate -group Extension
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/imm5
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/offset6
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/offset9
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/offset11
add wave -noupdate -format Literal /Test_LC3/DUT/WB/psr
add wave -noupdate -format Literal /Test_LC3/DUT/Ex/Mem_Control_out
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ctrl/mem_ctrl_Nstate
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ctrl/mem_ctrl_Cstate
add wave -noupdate -format Literal /Test_LC3/DUT/Ctrl/mem_state
add wave -noupdate -format Logic /Test_LC3/DUT/Ctrl/stall_pipe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {105 ns} 0}
configure wave -namecolwidth 213
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ns} {158 ns}
