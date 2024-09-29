onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processorrv_tb/clk
add wave -noupdate /processorrv_tb/reset
add wave -noupdate -divider {Interfaz Memoria}
add wave -noupdate /processorrv_tb/iAddr
add wave -noupdate /processorrv_tb/iDataIn
add wave -noupdate /processorrv_tb/dWrEn
add wave -noupdate /processorrv_tb/dRdEn
add wave -noupdate /processorrv_tb/dAddr
add wave -noupdate /processorrv_tb/dDataIn
add wave -noupdate /processorrv_tb/dDataOut
add wave -noupdate -divider {Banco Registros}
add wave -noupdate -childformat {{/processorrv_tb/i_processor/RegsRISCV/regs(4) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(5) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(6) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(7) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(8) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(9) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(10) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(11) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(12) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(13) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(14) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(15) -radix hexadecimal} {/processorrv_tb/i_processor/RegsRISCV/regs(16) -radix hexadecimal}} -subitemconfig {/processorrv_tb/i_processor/RegsRISCV/regs(4) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(5) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(6) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(7) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(8) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(9) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(10) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(11) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(12) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(13) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(14) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(15) {-height 17 -radix hexadecimal} /processorrv_tb/i_processor/RegsRISCV/regs(16) {-height 17 -radix hexadecimal}} /processorrv_tb/i_processor/RegsRISCV/regs
add wave -noupdate -divider {PC values}
add wave -noupdate /processorrv_tb/i_processor/PC_next
add wave -noupdate /processorrv_tb/i_processor/Addr_BranchJal
add wave -noupdate /processorrv_tb/i_processor/Addr_Jalr
add wave -noupdate -divider {Alu - Entradas Salidas}
add wave -noupdate -radix hexadecimal /processorrv_tb/i_processor/Alu_Op1
add wave -noupdate -radix hexadecimal /processorrv_tb/i_processor/Alu_Op2
add wave -noupdate -divider {Control Riesgos - Hazards}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {218 ns}
