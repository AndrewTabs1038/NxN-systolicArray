module systolic_array #(
    parameter DWIDTH = 32,
    parameter N = 32
) (
    input clk, rstn,
    input logic [DWIDTH-1:0] north [N-1:0],
    input logic [DWIDTH-1:0] west [N-1:0],

    // TODO: Add output buffer
    output logic [2*DWIDTH-1:0] results [N*N-1:0]
    // TODO: Implement done signal
    // output done
); 
    // localparam DONE_CYCLES = ;

    logic [N*N-1:0] ens;

    logic [DWIDTH-1:0] north_in [N*N-1:0];
    logic [DWIDTH-1:0] west_in [N*N-1:0];
    logic [DWIDTH-1:0] south_out [N*N-1:0];
    logic [DWIDTH-1:0] east_out [N*N-1:0];

    logic [31:0] counter;

    genvar i;

    //col -> i%N
    //row -> i/N

    generate 
        for (i=0;i<N*N;i++) begin:gen_loop    
            if (i<N) begin //North inputs
                assign north_in[i] = north[i];
            end 
            else begin //Inner connections
                assign north_in[i] = south_out[i-N];
            end

            if (i<N) begin //West inputs
                assign west_in[i] = west[i];
            end
            else begin 
                assign west_in[i] = east_out[i-1];
            end

            // counter < N+1+(i%N)+row -> result produced 
            // counter >= row+(i%N) -> inputs valid
            assign ens[i] = (counter >= (i/N)+(i%N)) && (counter < N+1+(i%N)+(i/N));

            PE #(
                .DWIDTH(DWIDTH)
            )PE_inst(
                .clk(clk),
                .rstn(rstn),
                .en(ens[i]),
                .west_in(west_in[i]),
                .north_in(north_in[i]),
                .south_out(south_out[i]),
                .east_out(east_out[i]),
                .result_out(results[i])
            );
        end:gen_loop
    endgenerate

    always @(posedge clk) begin 
        if(~rstn) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
    
    
endmodule