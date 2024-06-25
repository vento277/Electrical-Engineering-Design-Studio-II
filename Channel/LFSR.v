module LFSR (
  input clk,
  output [7:0] lfsr_out
);

  reg [7:0] lfsr_reg = 8'b00000011;
  wire [0:0] feedback;

  always @(posedge clk) begin
     lfsr_reg <= {lfsr_reg[6:0], feedback};
  end

  assign feedback = lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^ lfsr_reg[3];

  assign lfsr_out = lfsr_reg;

endmodule 