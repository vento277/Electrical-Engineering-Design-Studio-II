`timescale 1ns / 1ns

module qpsk_demod_tb;

    // Inputs
    reg signed [6:0] in0_re;
    reg signed [6:0] in0_im;
    reg err;
    
    // Outputs
    wire out0_0;
    wire out0_1;

    // Instantiate the module under test
    M_PSK_Demodulator_Baseband dut (
        .in0_re(in0_re),
        .in0_im(in0_im),
        .out0_0(out0_0),
        .out0_1(out0_1)
    );

    // Stimulus
    initial begin
        err = 1'b0;

        // Test case 1: in0_re and in0_im are both zero
        in0_re = 7'b0101101;
        in0_im = 7'b0101101; #10;
        if (out0_0 != 8'b00000000 | out0_1 != 8'b00000000) begin err <= 1'b1; end
        $display("Expected: 0 0, Output: %1b %1b",out0_0, out0_1); 
        #10;
        
        // Test case 2: in0_re is positive, in0_im is negative
        in0_re = 8'b1010011;
        in0_im = 8'b0101101; #10;
        if (out0_0 != 8'b00000000 | out0_1 != 8'b00000001) begin err <= 1'b1; end
        $display("Expected: 0 1, Output: %1b %1b",out0_0, out0_1); 
        #10;

        // Test case 3: in0_re is negative, in0_im is positive
        in0_re = 8'b0101101;
        in0_im = 8'b1010011; #10;
        if (out0_0 != 8'b00000001 | out0_1 != 8'b00000000) begin err <= 1'b1; end
        $display("Expected: 1 0, Output: %1b %1b",out0_0, out0_1); 
        #10;

        // Test case 4: in0_re and in0_im are both negative
        in0_re = 8'b1010011;
        in0_im = 8'b1010011; #10;
        if (out0_0 != 8'b00000001 | out0_1 != 8'b00000001) begin err <= 1'b1; end
        $display("Expected: 1 1, Output: %1b %1b",out0_0, out0_1); 
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

