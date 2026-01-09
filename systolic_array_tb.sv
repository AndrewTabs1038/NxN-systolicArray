`timescale 1ps/1ps

// Simple test showcase basic functionality
module systolic_array_tb;

    localparam DWIDTH = 32;
    localparam N = 3;

    logic clk, rstn;
    logic [DWIDTH-1:0] north [N];
    logic [DWIDTH-1:0] west [N];
    logic [2*DWIDTH-1:0] results [N*N];

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

    logic [DWIDTH-1:0] A [9];
    logic [DWIDTH-1:0] B [9];
    logic [DWIDTH-1:0] C [9];

    logic [DWIDTH*2-1:0] expectedResult[9];

    logic [DWIDTH-1:0] north_buff0 [5];
    logic [DWIDTH-1:0] west_buff0 [5];

    logic [DWIDTH-1:0] north_buff1 [5];
    logic [DWIDTH-1:0] west_buff1 [5];

    logic [DWIDTH-1:0] north_buff2 [5];
    logic [DWIDTH-1:0] west_buff2 [5];

    int i;

    assign north[0] = north_buff0[i];
    assign north[1] = north_buff1[i];
    assign north[2] = north_buff2[i];

    assign west[0] = west_buff0[i];
    assign west[1] = west_buff1[i];
    assign west[2] = west_buff2[i];

    initial begin
        clk = 0; rstn = 0; i = 0;

        //*_buff variables to simulate buffers
        north_buff0 = {10,13,16,'x,'x};
        west_buff0 = {1,2,3, 'x, 'x};

        north_buff1 = {'x,11,14,17,'x};
        west_buff1 = {'x,4,5,6,'x};

        north_buff2 = {'x,'x,12,15,18};
        west_buff2 = {'x,'x,7,8,9};

        expectedResult = {
            84,  90,  96,
            201, 216, 231,
            318, 342, 366
        };

        #1; clk = 1;
        #1; clk = ~clk;
        #1; clk = ~clk;
        #1; rstn = 1;
        clk = 0; i = 0;      
        repeat(20) begin // Should be able to go past min number of clk cycles w/o error
            if(clk == 1) i++;
            #1;
            clk = ~clk;
            #1;
        end

        for(i=0;i<N*N;i++) begin //repurpose i for checking for assertions
            assert (results[i] == expectedResult[i]) 
            else $error ("ERROR, Incorrect Value: expected: %0d actual: %0d",expectedResult[i], results[i]);
        end   
    end
endmodule