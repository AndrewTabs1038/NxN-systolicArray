vlib work
vmap work work
vlog PE.sv systolic_array.sv systolic_array_32tb.sv
vsim -t 1ps systolic_array_32tb
add wave -radix decimal sim:/systolic_array_32tb/UUT/*
add wave -radix decimal sim:/systolic_array_32tb/UUT/north_in
add wave -radix decimal sim:/systolic_array_32tb/UUT/west_in
add wave -radix decimal sim:/systolic_array_32tb/UUT/south_out
add wave -radix decimal sim:/systolic_array_32tb/UUT/east_out
add wave -radix decimal sim:/systolic_array_32tb/UUT/results
run 3ns