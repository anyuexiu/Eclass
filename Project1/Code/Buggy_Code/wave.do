onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/clock
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/reset
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/complete_instr
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/Fetch/br_taken
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Fetch/taddr
add wave -noupdate -color Orange -format Literal -radix hexadecimal /Test_LC3/DUT/pc
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Dec/npc_out
add wave -noupdate -format Logic -radix hexadecimal /Test_LC3/DUT/instrmem_rd
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Instr_dout
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/IR
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/aluout
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/MemAccess/memout
add wave -noupdate -format Literal /Test_LC3/DUT/Ctrl/prev_enables
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ctrl/state
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ctrl/next_state
add wave -noupdate -format Literal -radix unsigned /Test_LC3/DUT/Ex/dr
add wave -noupdate -format Literal -radix hexadecimal /Test_LC3/DUT/Ctrl/IR
add wave -noupdate -group BubbleCount
add wave -noupdate -group Extension
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/imm5
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/offset6
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/offset9
add wave -noupdate -group Extension -format Literal -radix hexadecimal /Test_LC3/DUT/Ex/offset11
add wave -noupdate -format Literal /Test_LC3/DUT/WB/psr
add wave -noupdate -format Literal /Test_LC3/DUT/Ex/Mem_Control_out
add wave -noupdate -format Literal /Test_LC3/DUT/Ctrl/mem_state
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {158 ns}
