module input_buffer_tb;

    localparam DWIDTH = 32;
    localparam N = 3;

    logic [DWIDTH-1:0] A [N*N];
    logic [DWIDTH-1:0] B [N*N];


    logic clk, rstn, valid_in,ready;
    logic [DWIDTH-1:0] Ain [N];
    logic [DWIDTH-1:0] Bin [N];
    
    logic valid_out;
    logic [DWIDTH-1:0] Aout [N];
    logic [DWIDTH-1:0] Bout [N];

    int i;


    input_buffer #(
        .DWIDTH(DWIDTH),
        .N(N)
    ) UUT (
        .clk(clk),
        .rstn(rstn),
        .valid_in(valid_in),
        .Ain(Ain), 
        .Bin(Bin),  
        .valid_out(valid_out),
        .Aout(Aout),
        .Bout(Bout)
    );


    assign A = {
        1, 2, 3,
        4, 5, 6, 
        7, 8, 9
    };

    assign B = {
        10, 11, 12,
        13, 14, 15, 
        16, 17, 18
    };   

    genvar j;
    generate 
        for(j=0;j<N;j++) begin: assign_loop
            assign Ain[j] = A[i+j];
            assign Bin[j] = B[i+j];
        end: assign_loop
    endgenerate


    initial begin
        rstn = 0; clk = 0; i = 0; valid_in = 1;
        ready = 0;
        #1;
        clk = 1;
        #1;
        clk = 0; rstn = 1;
        #1;
        repeat (N*N) begin
            clk = ~clk;
            #1;
            if(clk) i = i + N;
        end
    end
endmodule