`timescale 1 ns / 1 ns

module EncDec_tb;

  // Define parameters
  parameter CLK_PERIOD = 10;  // Clock period in time units
  parameter MAX_VALUE = 200;  // Maximum value for counter

  // Declare signals
  reg clk;
  reg reset;
  reg enb;
  reg [15:0] bit_in;
  reg CE_in;
  reg flag;
  
  wire bit_out;
  wire CE_out_0, CE_out_1, CE_out_A, CE_out_B;
  wire D_out, D_out_S;

  // Instantiate Convolutional Code to only test the convolutional.
  CE dut_single (
    .clk(clk),
    .reset(reset),
    .enb(enb),
    .CE_in(CE_in), // Connect the serializer output to the input of the encoder.
    .CE_out_0(CE_out_A),
    .CE_out_1(CE_out_B)
  );
 
    // Instantiate Viterbi Decoder
  Viterbi_Decoder vdut_single(
  .clk(clk),
  .reset(reset),
  .enb(enb),
  .Viterbi_Decoder_in_0(CE_out_A), // Connect the encoder output to the decoder input. 
  .Viterbi_Decoder_in_1(CE_out_B), // Connect the encoder output to the decoder input. 
  .decoded(D_out_S)
  );

    // Instantiate 16bit Serializer
  BitSequenceProcessorOneBit16 but(
    .input_16bit(bit_in),
    .output_1bit(bit_out),
    .clk(clk),
    .rst(reset)
  );

    // Instantiate Convolutional Code
  CE dut (
    .clk(clk),
    .reset(reset),
    .enb(enb),
    .CE_in(bit_out), // Connect the serializer output to the input of the encoder.
    .CE_out_0(CE_out_0),
    .CE_out_1(CE_out_1)
  );

  // Instantiate Viterbi Decoder
  Viterbi_Decoder vdut(
  .clk(clk),
  .reset(reset),
  .enb(enb),
  .Viterbi_Decoder_in_0(CE_out_0), // Connect the encoder output to the decoder input. 
  .Viterbi_Decoder_in_1(CE_out_1), // Connect the encoder output to the decoder input. 
  .decoded(D_out)
  );


  // Clock generation process
  always #(CLK_PERIOD / 2) clk = ~clk;

  // Initial values
  initial begin
    clk = 0;
    reset = 1'b1;
    enb = 1'b0;
    CE_in = 1'b0;
    bit_in = 16'b0;
    flag = 1'b0;

    // Reset sequence
    #10 reset = 1'b0;
    enb = 1'b1;
    flag = 1'b1;

    // Initiall known test cases to confirm functionality. 
    #10 CE_in = 1'b0;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b0;
    #10 CE_in = 1'b0;
    $display("Expected output = 00 11 01 10 01 11");
    flag = 1'b0; // Flag to see when the input stops.

    #500; // Delay to see the decoder output. 

    #10 reset = 1'b1;
    #10 reset = 1'b0;
    flag = 1'b1;

    #10 CE_in = 1'b1;
    #10 CE_in = 1'b0;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b0;
    $display("Expected output = 11 10 00 01 10 01");
    flag = 1'b0; // Flag to see when the input stops.

    #500; // Delay to see the decoder output. 

    #10 reset = 1'b1;
    #10 reset = 1'b0;
    flag = 1'b1;

    #10 CE_in = 1'b1;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b0;
    #10 CE_in = 1'b1;
    #10 CE_in = 1'b1;
    $display("Expected output = 11 01 10 01 00 01");
    flag = 1'b0; // Flag to see when the input stops.

    #500; // Delay to see the decoder output. 

    // Reset and continue with incremental inputs to test more cases. 
    enb = 1'b0;
    #10 reset = 1'b1;
    #10 reset = 1'b0;
    flag = 1'b1;
    #10 CE_in = 1'b0;
    enb = 1'b1;
  end

  // Input 16bit incrementally to test various cases.
  always @(posedge clk) begin
    if (reset) begin
      bit_in <= 16'b0;
    end else begin
      bit_in <= bit_in + 1; // Increment the input by 1. 
      #50;
      if (bit_in == MAX_VALUE) begin
        $stop;
      end
    end
  end
endmodule
