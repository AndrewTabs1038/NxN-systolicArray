module PE #(
    parameter DWIDTH = 32
) (
    input clk, rstn, en,
    input [DWIDTH-1:0] west_in, north_in,
    output [DWIDTH-1:0] south_out, east_out,
    output [DWIDTH-1:0] result_out
);

    logic [DWIDTH-1:0] south_out_temp, east_out_temp, result, mult;

    assign south_out = south_out_temp;
    assign east_out = east_out_temp;
    assign result_out = result;

    assign mult = west_in * north_in;

    always @(posedge clk) begin
        if(~rstn) begin 
            result <= 0;
            south_out_temp <= 0;
            east_out_temp <= 0;
        end
        else begin
            if(en) result <= result + mult;
            south_out_temp <= north_in;
            east_out_temp <= west_in;
        end        
    end    
endmodule