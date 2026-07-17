module input_buffer #(
    parameter DWIDTH = 32,
    parameter N = 32
) (
    input clk, rstn, valid_in, ready,
    input logic [DWIDTH-1:0] Ain [N], //west
    input logic [DWIDTH-1:0] Bin [N], //north
    
    output logic valid_out,
    output logic [DWIDTH-1:0] Aout [N],
    output logic [DWIDTH-1:0] Bout [N]
);

    logic [DWIDTH-1:0] A_buff [N*N];
    logic [DWIDTH-1:0] B_buff [N*N];

    logic [31:0] counter;

    logic buffer_filled;

    int i, j;
    always_ff @(posedge clk) begin
        if(~rstn) begin
            valid_out <= 1'b0;
            counter <= 0;
            buffer_filled <= 1'b0;
        end
        else if(valid_in & ~buffer_filled) begin
            counter <= counter + N;
            for(i=0;i<N;i++) begin
                A_buff[counter+i] <= Ain[i];
                B_buff[counter+i] <= Bin[i];
            end
            if(counter == N*(N-1)) begin
                buffer_filled <= 1'b1;
                counter <= 0;
            end
        end
        else (buffer_filled & ready) begin
            valid_out <= 1'b1;
            counter <= counter + 1;
            for(i=0;i<N;i++) begin
                // if(counter == 0) begin
                //     Aout[i] <= A_buff[i+1];
                //     Bout[i] <= B_buff[i+N]; 
                // end
                if(counter >= i) begin
                    Aout[i] <= A_buff[counter+i];
                    Bout[i] <= B_buff[counter+i*N];                    
                end            
            end
            // if(counter == N*(N-1)) begin
            //     buffer_filled <= 1'b0;
            //     counter <= 0;
            // end
        end
    end
endmodule