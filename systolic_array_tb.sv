`timescale 1ps/1ps

module systolic_array_tb;

    localparam DWIDTH = 32;
    localparam N = 4;

    systolic_array #(
        .DWIDTH(DWIDTH),
        .N(N)
    ) UUT (
        input clk, rstn,
        input logic [DWIDTH-1:0] north [N-1:0],
        input logic [DWIDTH-1:0] west [N-1:0],

        // TODO: Add output buffer
        output logic [DWIDTH-1:0] results [N*N-1:0]
        // TODO: Implement done signal
        // output done
    ); 


endmodule