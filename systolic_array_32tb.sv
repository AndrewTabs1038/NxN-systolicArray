`timescale 1ps/1ps
// Tests 32x32 Systolic Array
module systolic_array_32tb;

    localparam DWIDTH = 32;
    localparam N = 32;

    localparam PRINT_MATRICES = 0;

    logic clk, rstn;
    logic [DWIDTH-1:0] north [N];
    logic [DWIDTH-1:0] west [N];
    logic [2*DWIDTH-1:0] results [N*N];

    logic [DWIDTH-1:0] north_input [N*N];
    logic [DWIDTH-1:0] west_input [N*N];
    logic [2*DWIDTH-1:0] expected_results [N*N];

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

    int i,j,n;

    logic [DWIDTH-1:0] north_buff [N][N+N-1];
    logic [DWIDTH-1:0] west_buff [N][N+N-1];

    genvar k;
    generate 
        for(k=0;k<N;k++) begin: assign_loop
            assign north[k] = north_buff[k][i];
            assign west[k] = west_buff[k][i]; 
        end: assign_loop
    endgenerate

    initial begin
        $readmemh("A.mem",west_input);
        $readmemh("B.mem",north_input);
        $readmemh("C.mem",expected_results);

        n=0;
        for(i=0;i<N;i++) begin
            for(j=0;j<N+N-1;j++) begin
                if(j<i || j>(i+N-1)) begin
                    west_buff[i][j] = 'x; //Values shouldn't be used
                end
                else begin 
                    west_buff[i][j] = west_input[n];
                    north_buff[i][j] = north_input[n]; // north_input already in coloumn major order
                    n++;
                end
            end
        end

        if(PRINT_MATRICES) begin
            for (i=0;i<N;i++) begin
                $display("A[%0d]",i);
                for (j=0;j<N+N-1;j++) begin   
                    $display(west_buff[i][j]);
                end

                $display("B[%0d]",i);
                for (j=0;j<N+N-1;j++) begin 
                    $display(north_buff[i][j]);
                end
            end
        end

        rstn = 0; clk = 0; i = 0;
        #1; clk = 1;
        #1; clk = ~clk;
        #1; clk = ~clk;
        #1; rstn = 1;
        clk = 0; i = 0;      
        repeat(N*N) begin //Go well over min cycles
            if(clk == 1) i++;
            #1;
            clk = ~clk;
            #1;
        end

        for(i=0;i<N*N;i++) begin //repurpose i for checking for assertions
            assert (results[i] == expected_results[i]) 
            else $error ("ERROR, Incorrect Value: expected: %0d actual: %0d",expected_results[i], results[i]);
        end 
        $display("TEST COMPLETED");
    end
endmodule