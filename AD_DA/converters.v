/*--------------------------------------------------------------------------
    ADC Module
    samples audio codec at rate given by slow_clock and outputs number of 
    bits equal to quantization parameter
--------------------------------------------------------------------------*/  
module ADC(data_in, data_out, ready, enable, fast_clock, slow_clock, reset);
    
    //Quantization parameter
    parameter N = 8;

    //IO signals
    input [23:0] data_in;
    output reg [N-1:0] data_out;
    input ready;
    output reg enable;
    input fast_clock, slow_clock, reset;

    //internal signals
    reg disable_read;
    
    //logic to read from audio codec
    always@(posedge(fast_clock)) begin
        if(reset == 1) begin
            enable = 0;
			disable_read = 0;
        end

        //if slow_clock has recently turned to 1 (positive edge)
        if(slow_clock == 1 && disable_read == 0) begin

            //if ready is equal to 1, then read quantization number of bits from codec and assert enable to get new sample
            if(ready == 1) begin
                enable = 1;
                data_out = data_in[23:24-N];
            end

            //if codec is busy getting new signal, deassert enable and disable read until new posedge on slow clock
            else if(ready == 0) begin
                enable = 0;
                disable_read = 1;
            end
        end

        //if slow clock has cycled to zero, enable read and wait for slow clock to turn back to 1 (posedge)
        else if(slow_clock == 0 && disable_read == 1) begin
            disable_read = 0;
        end
    end

endmodule

/*--------------------------------------------------------------------------
    DAC Module
    scales input from quantization parameter back to 24 bit width of audio
    codec and outputs at sample rate given by slow_clock
--------------------------------------------------------------------------*/  
module DAC(data_in, data_out, ready, enable, fast_clock, slow_clock, reset);
    
    //Quantization parameter
    parameter N = 8;

    //IO signals
    input [7:0] data_in;
    output reg [23:0] data_out;
    input ready;
    output reg enable;
    input fast_clock, slow_clock, reset;

    //internal signals
    reg disable_write;
    
    //logic to read from audio codec
    always@(posedge(fast_clock)) begin
        if(reset == 1) begin
            enable = 0;
			disable_write = 0;
        end

        //if slow clock has recently turned to 1 (posedge)
        if(slow_clock == 1 && disable_write == 0) begin
            
            //if codec is ready, then pass data scaled up to 24 bits and assert enable
            if(ready == 1) begin
                enable = 1;
                data_out = {data_in, {24-N{1'b0}}};
            end

            //if codec is busy fetching new sample, deassert enable and disable write until new posedge on slow clock
            if(ready == 0) begin
                enable = 0;
                disable_write = 1;
            end

        end

        //if slow clock has cycled to zero, enable write and then wait for slow clock to cycle back to 1 (posedge)
        else if(slow_clock == 0 && disable_write == 1) begin
            disable_write = 0;
        end
    end

endmodule