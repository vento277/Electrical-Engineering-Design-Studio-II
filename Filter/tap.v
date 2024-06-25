module tap(reset, clk, data_in, data_out, coef, sum_in, sum_out);
    input reset, clk;
    input signed [7:0] data_in;
    input signed [15:0] coef;
    input signed [23:0] sum_in;
    output reg signed [7:0] data_out;
    output reg signed [23:0] sum_out;
    always@(posedge clk) begin
        if(reset) begin
			  sum_out <= 0;
			  data_out <= 0;
        end else begin
			  data_out <= data_in;
			  sum_out <= sum_in + coef * data_in;
        end
    end
endmodule