vlib work
vmap work work
vlog PE.sv systolic_array.sv systolic_array_tb.sv
vsim -t 1ps systolic_array_tb
add wave -radix decimal sim:/systolic_array_tb/UUT/*
add wave -radix decimal sim:/systolic_array_tb/UUT/north_in
add wave -radix decimal sim:/systolic_array_tb/UUT/west_in
add wave -radix decimal sim:/systolic_array_tb/UUT/south_out
add wave -radix decimal sim:/systolic_array_tb/UUT/east_out
add wave -radix decimal sim:/systolic_array_tb/UUT/results
run 100ps
