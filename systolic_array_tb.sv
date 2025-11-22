`timescale 1ps/1ps

//Currently just does a simple test
module systolic_array_tb;

    localparam DWIDTH = 32;
    localparam N = 3;

    logic clk, rstn;
    logic [DWIDTH-1:0] north [N-1:0];
    logic [DWIDTH-1:0] west [N-1:0];
    logic [2*DWIDTH-1:0] results [N*N-1:0];

    int counter;

    systolic_array #(
        .DWIDTH(DWIDTH),
        .N(N)
    ) UUT (
        .clk(clk),
        .rstn(rstn),
        .north(north),
        .west(west),
        .results(results)
    );

    /*
        A -> west input in row major order
        B -> north input in coloumn major order
        Performs C = A * B
        A: 
            1   2   3 
            4   5   6
            7   8   9 

        B:
            10  11  12 
            13  14  15
            16  17  18

        C:        
            84  90  96
            201 216 231
            318 342 366
    */

    int curr = 1; 

    task inputSwitch();
        int i;
        for (i=0;i<N;i++) begin
            west[i] = curr + i;
            north[i] = curr + 9 + 3*i; 
        end
        curr = curr + 3;
    endtask

    initial begin
        clk = 0; rstn = 0;
        #1;
        clk = 1;
        #1; rstn = 1;
        inputSwitch();
        repeat (20) begin 
            #1; clk = ~clk;
            #1; if (clk == 1) inputSwitch(); 
        end
    end
endmodule