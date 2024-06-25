module part1 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4);
				  
	input CLOCK_50, CLOCK2_50;
	input [3:0] KEY;
	output [9:0] LEDR;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;

	// Local wires.
	wire read, write;
	wire read_ready, write_ready;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
	
	/////////////////////////////////

	//instantiating wires and regs to be used in design
	wire [Q_BIT_WIDTH-1:0] data_in_L, data_in_R;
	wire [23:0] data_out_L, data_out_R;
	wire [Q_BIT_WIDTH-1:0] data_21_Re, data_21_Im, data_9_Re, data_9_Im, data_2_Re, data_2_Im;
	wire [Q_BIT_WIDTH*2-1:0] data_AD_bus, data_DA_bus, data_AD_bus_test, data_DA_bus_test;
	reg CLOCK_40K, CLOCK_1M, CLOCK_10K;
	reg [10:0] counter_40K;
	reg [4:0] counter_1M;
	reg [1:0] counter_10K;
	reg write_enable, read_enable;

	wire [1:0] bus_to_QPSK;
	wire [1:0] bus_to_debuffer;
	wire signed [6:0] out0_re, out0_im;
	wire signed [15:0] channel_out_bus;
	wire signed [15:0] tout, fout;
	wire signed [7:0] chnl_re, chnl_im, tx_re, tx_im, rx_re, rx_im;
	wire signed [6:0] rx_re_out, rx_im_out;
	wire [15:0] wire_count;

	wire right_write_ready, right_write, right_read_ready, right_read; //unused signals used as placeholders in right side converters
	wire serialout, D_out, flag, CE_out_P7,  CE_out_P5;
	
	parameter Q_BIT_WIDTH = 8;

	//generating 40kHz clock signal for AD & 1MHz clock signal for AWGN
	always@(posedge(CLOCK_50)) begin
        if(reset == 1) begin
            counter_40K = 0;
			CLOCK_40K = 0;
			counter_1M = 0;
			CLOCK_1M = 0;
        end
        counter_40K = counter_40K + 1;
			counter_1M = counter_1M + 1;
        if(counter_40K == 11'd625) begin
            counter_40K = 11'd0;
            CLOCK_40K = ~CLOCK_40K;
        end
		if(counter_1M == 5'd25) begin
            counter_1M = 5'd0;
            CLOCK_1M = ~CLOCK_1M;
        end
	end
	//generating 10kHz clock signal for Gilbert Model
	always@(posedge(CLOCK_40K)) begin
        if(reset == 1) begin
            counter_10K = 0;
				CLOCK_10K = 0;
        end
        counter_10K = counter_10K + 1;
        if(counter_10K == 2'd2) begin
            counter_10K = 2'd0;
            CLOCK_10K = ~CLOCK_10K;
        end
	end

	//ADCs, writes to data_AD_bus
	ADC ADC_L(readdata_left, data_in_L, write_ready, write, CLOCK_50, CLOCK_40K, reset);
	ADC ADC_R(readdata_right, data_in_R, write_ready, right_write, CLOCK_50, CLOCK_40K, reset);
		
	//Busing ADC outputs to rest of system
	assign data_AD_bus = {data_in_L, data_in_R};

	// Buffer to sequentially send bus bits to QPSK
	buffer dut_buf(data_AD_bus, serialout, CLOCK_40K, CLOCK_50, reset);

	// Convolutional Encoder	
	CE encode(CLOCK_50, reset, 1'b1, serialout, bus_to_QPSK[0], bus_to_QPSK[1]);
	
	// QPSK Modulator
	M_PSK_Modulator_Baseband dut_mod(bus_to_QPSK[0], bus_to_QPSK[1], out0_re, out0_im);
	
	// Transmitter
	//Raised_Cosine_Transmit_Filter(CLOCK_50, reset, 1'b1, {out0_re[6], out0_re}, {out0_im[6], out0_im}, tx_re, tx_im);
	SRRC_filter Transmit_Re(CLOCK_50, reset, {out0_re[6], out0_re}, tx_re);
   SRRC_filter Transmit_Im(CLOCK_50, reset, {out0_im[6], out0_im}, tx_im);

	// AWGN channels
	//AWGN_2 CHNL_Re_2(tx_re, data_9_Re, CLOCK_1M, reset);
	//AWGN_2 CHNL_Im_2(tx_im, data_9_Im, CLOCK_1M, reset);
	AWGN_9 CHNL_Re_9(tx_re, data_9_Re, CLOCK_1M, reset);
	AWGN_9 CHNL_Im_9(tx_im, data_9_Im, CLOCK_1M, reset);
	AWGN_21 CHNL_Re_21(tx_re, data_21_Re, CLOCK_1M, reset);
	AWGN_21 CHNL_Im_21(tx_im, data_21_Im, CLOCK_1M, reset);
	Gilbert_model Gilbert(CLOCK_10K, reset, data_21_Re, data_21_Im, data_9_Re, data_9_Im, chnl_re, chnl_im);

	// Receiver
	//Raised_Cosine_Receive_Filter(CLOCK_50, reset, 1'b1, chnl_re, chnl_im, rx_re, rx_im);
	SRRC_filter Receive_Re(CLOCK_50, reset, chnl_re, rx_re);
   SRRC_filter Receive_Im(CLOCK_50, reset, chnl_im, rx_im);
	
	// QPSK Demodulator
	overflow_detect det1(rx_re, rx_re_out);
	overflow_detect det2(rx_im, rx_im_out);
	M_PSK_Demodulator_Baseband(rx_re_out, rx_im_out, bus_to_debuffer[0], bus_to_debuffer[1]);
	
	// Viterbi Decoder
	Viterbi_Decoder decode(CLOCK_50, reset, 1'b1, bus_to_debuffer[0], bus_to_debuffer[1], D_out);

	// Debuffer to assemble sequential buts into 16 bit bus
	debuffer dut_debuf(D_out, data_DA_bus, CLOCK_40K, CLOCK_50, reset);

	// DACs, reads from data_DA_bus
	DAC DAC_L(KEY[3]?data_DA_bus[15:8]:data_AD_bus[15:8], writedata_left, read_ready, read, CLOCK_50, CLOCK_40K, reset);
	DAC DAC_R(KEY[3]?data_DA_bus[7:0]:data_AD_bus[7:0], writedata_right, read_ready, right_read, CLOCK_50, CLOCK_40K, reset);
	
	BER_counter(data_in_L, data_DA_bus[15:8], wire_count, CLOCK_50, ~KEY[2]);
	seven_seg_controller(wire_count, HEX0, HEX1, HEX2, HEX3, HEX4);
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read, write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule





