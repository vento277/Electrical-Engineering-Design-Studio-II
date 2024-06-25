/*--------------------------------------------------------------------------
    Buffer Module
    takes 16 bit input every posedge of slow_clock, and outputs 1 bits 
    at a time sequentially on posedge of fast_clock until entire bus has
    been read.
--------------------------------------------------------------------------*/ 
module buffer(data_in, data_out, slow_clock, fast_clock, reset);

//IO signals
input [15:0] data_in;
output reg data_out;
input slow_clock, fast_clock, reset;

//internatl signals
reg[4:0] counter;
reg[1:0] state, next_state;

//always block to update states and counter signals on clock edge
always@(posedge(fast_clock)) begin
   if(reset == 1) begin
    counter = 0;
    state = 2'b11;
   end
   else begin
        if(state == 2'b01) begin
            counter = counter + 1;
        end
        else if(state != 2'b01) begin
            counter = 4'd0;
        end
        state = next_state;
   end
end

//combinational logic to determine outputs and state transitions
always@(*) begin
    case(state)
        //state should not be used, only here to avoid inferred latches
        2'b00: begin 
            next_state = 2'b01;
            data_out = 0;
        end
        //WRITE: sequentially writing bits from bus, at end of bus, proceed to wait1
        2'b01: begin
            next_state = 2'b01;
                data_out = data_in[counter];
            if(counter == 4'd15) begin
                next_state = 2'b10;
            end
        end
        //WAIT1: wait for slow_clock to go to zero before proceeding to wait2
        2'b10: begin
            next_state = 2'b10;
            data_out = 2'b00;
            if(slow_clock == 0) begin
                next_state = 2'b11;
            end
        end
        //WAIT2: when clock is low, check for slow clock == 1 (posedge) then transition to WRITE state
        2'b11: begin
            next_state = 2'b11;
            data_out = 2'b00;
            if(slow_clock == 1) begin
                next_state = 2'b01;
            end
        end
    endcase
end
endmodule

/*--------------------------------------------------------------------------
    Debuffer Module
    On posedge of slow clock, sequentially reads 1 bits every posedge of
    fast_clock. After 8 inputs, module outputs result to 16 bit bus.
--------------------------------------------------------------------------*/ 
module debuffer(data_in, data_out, slow_clock, fast_clock, reset);

//IO signals
input data_in;
output reg [15:0] data_out;
input slow_clock, fast_clock, reset;

//internal signals
reg[3:0] counter;
reg [6:0] wait_counter;
reg[1:0] state, next_state;
reg data_out_15, data_out_14, data_out_13, data_out_12, data_out_11, data_out_10, data_out_9, data_out_8, data_out_7, data_out_6, data_out_5, data_out_4, data_out_3, data_out_2, data_out_1, data_out_0;

//sequential always block to assign data_out
always@(posedge(fast_clock)) begin
   if(reset == 1) begin
        counter = 0;
        state = 2'b10;
   end
   else begin
        //WRITE STATE: write to 16 internal bits
        if(state == 2'b00) begin
            case(counter)
                4'd15:data_out_15 = data_in;
                4'd14:data_out_14 = data_in;
                4'd13:data_out_13 = data_in;
                4'd12:data_out_12 = data_in;
                4'd11:data_out_11 = data_in;
                4'd10:data_out_10 = data_in;
                4'd9:data_out_9 = data_in;
                4'd8:data_out_8 = data_in;
                4'd7:data_out_7 = data_in;
                4'd6:data_out_6 = data_in;
                4'd5:data_out_5 = data_in;
                4'd4:data_out_4 = data_in;
                4'd3:data_out_3 = data_in;
                4'd2:data_out_2 = data_in;
                4'd1:data_out_1 = data_in;
                4'd0:data_out_0 = data_in;
            endcase
            counter = counter + 1;
        end
        //WAIT STATES, assign new internal bits to data_out
        else if(state != 2'b00) begin
            counter = 4'd0;
            data_out = {data_out_15, data_out_14, data_out_13, data_out_12, data_out_11, data_out_10, data_out_9, data_out_8, data_out_7, data_out_6, data_out_5, data_out_4, data_out_3, data_out_2, data_out_1, data_out_0};
        end
        if(state == 2'b11) begin
            wait_counter = wait_counter + 1;
        end
        else if(state != 2'b11) begin
            wait_counter = 0;
        end
        state = next_state;
   end
end

//combinational logic to determine state transitions
always@(*) begin
    case(state)
        2'b00: begin
            next_state = 2'b00;
            if(counter == 4'd15) begin
                next_state = 2'b01;
            end
        end
        2'b01: begin
            next_state = 2'b01;
            if(slow_clock == 0) begin
                next_state = 2'b10;
            end
        end
        2'b10: begin
            next_state = 2'b10;
            if(slow_clock == 1) begin
                next_state = 2'b11;
            end
        end
        2'b11: begin
            next_state = 2'b11;
            if(wait_counter == 7'd71) begin
                next_state = 2'b00;
            end
        end
    endcase
end


endmodule