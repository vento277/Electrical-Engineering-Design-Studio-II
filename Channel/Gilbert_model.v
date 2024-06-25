module Gilbert_model(clk, reset, good_re, good_im, bad_re, bad_im, data_out_re, data_out_im);
	input clk, reset;
	input signed [7:0] good_re, good_im, bad_re, bad_im;
	output reg [7:0] data_out_re, data_out_im;
	integer p_GB = 8;			// 0.03*256
	integer p_BG = 64;		// 0.25*256
	parameter GOOD = 1, BAD = 0;
	reg [0:0] cur_state, next_state;
	reg [7:0] p;
	wire [7:0] random;
	
	LFSR random_number(
	  .clk(clk),
	  .lfsr_out(random)
	);
	
	// State transition and output logic
	always @(posedge clk) begin
		 if (reset) begin
			  cur_state <= GOOD; // Reset to good channel
		 end else begin
				p <= random ;// random numbers between 0 and 255.
			  cur_state <= next_state; // Update state based on next_state
		 end
	end

	// Next state logic
	always @(*) begin
		 case(cur_state)
			  GOOD: begin
					if (p < p_GB) begin
						 next_state = BAD; // Transition to bad channel
					end else begin
						 next_state = GOOD; // Stay in good otherwise
					end
			  end
			  BAD: begin
					if (p < p_BG) begin
						 next_state = GOOD; // Transition back to good channel
					end else begin
						 next_state = BAD; // Stay in bad otherwise
					end
			  end
		 endcase
	end

	// Output logic
	always @(*) begin
		 case(cur_state)
			  GOOD: begin
			    data_out_re = good_re; //AWGN with 21-SNR
                data_out_im = good_im;
			  end
			  BAD: begin
                data_out_re = bad_re; //AWGN with 9-SNR
                data_out_im = bad_im;
              end
		 endcase
	end

endmodule