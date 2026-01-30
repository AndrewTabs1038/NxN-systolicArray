vlib work
vmap work work
vlog input_buffer.sv input_buffer_tb.sv
vsim -t 1ps input_buffer_tb
add wave -radix decimal sim:/input_buffer_tb/UUT/*
add wave -radix decimal sim:/input_buffer_tb/UUT/A_buff
add wave -radix decimal sim:/input_buffer_tb/UUT/B_buff
add wave -radix decimal sim:/input_buffer_tb/UUT/Ain
add wave -radix decimal sim:/input_buffer_tb/UUT/Bin
run 3ns