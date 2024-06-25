`timescale 1ns / 1ns

module qpsk_mod_tb;

    // Inputs
    reg in0_0;
    reg in0_1;
    reg err;
    
    // Outputs
    wire signed [6:0] out0_re;
    wire signed [6:0] out0_im;

    // Instantiate the module under test
    M_PSK_Modulator_Baseband dut (
        .in0_0(in0_0),
        .in0_1(in0_1),
        .out0_re(out0_re),
        .out0_im(out0_im)
    );

    // Stimulus
    initial begin
        // Test case 1: Input 00
        err = 1'b0;

        // Test case 1: Input 00. Expected 1, 1 = 01011011, 01011011
        in0_0 = 1'b0;
        in0_1 = 1'b0; 
        #10;
        if (out0_re != 8'b0101101 | out0_im != 8'b0101101) begin err <= 1'b1; end
        $display("Expected: 0101101 0101101, Output: %7b %7b",out0_re, out0_im); 
        #10;
        

        // Test case 2: Input 01. Expected -1, 1 = 10100101, 01011011
        in0_0 = 1'b0;
        in0_1 = 1'b1; 
        #10;
        if (out0_re != 8'b1010011 | out0_im != 8'b0101101) begin err <= 1'b1; end
        $display("Expected: 0101101 0101101, Output: %7b %7b",out0_re, out0_im);
        #10;

        // Test case 3: Input 10. Expected 1, -1 = 01011011, 10100101
        in0_0 = 1'b1;
        in0_1 = 1'b0; 
        #10;
        if (out0_re != 8'b0101101 | out0_im != 8'b1010011) begin err <= 1'b1; end
        $display("Expected: 0101101 1010011, Output: %7b %7b",out0_re, out0_im);
        #10;

        // Test case 4: Input 11. Expected 1, 1 = 10100101, 10100101
        in0_0 = 1'b1;
        in0_1 = 1'b1; 
        #10;
        if (out0_re != 8'b1010011 | out0_im != 8'b1010011) begin err <= 1'b1; end
        $display("Expected: 1010011 1010011, Output: %7b %7b",out0_re, out0_im);
        #10;

        if (err == 0) begin
            $display("Test all passed.");
        end else begin
            $display("Test not passed.");
        end

        // End simulation
        $stop;
    end

    // Add any necessary logic to monitor outputs or verify functionality

endmodule

