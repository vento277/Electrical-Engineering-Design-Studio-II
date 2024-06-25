// -------------------------------------------------------------
// 
// File Name: C:\Users\TEMP\Desktop\fina\hdlcoder_commviterbi\ACS.v
// Created: 2024-06-14 20:40:48
// 
// Generated by MATLAB 9.13 and HDL Coder 4.0
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: ACS
// Source Path: hdlcoder_commviterbi/Subsystem/Viterbi Decoder/ACS
// Hierarchy Level: 2
// 
// ACS: connects the add-compare and select units
// and performs the state metric normalization
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module ACS
          (clk,
           reset,
           enb,
           acs_in_0,
           acs_in_1,
           acs_in_2,
           acs_in_3,
           dec_0,
           dec_1,
           dec_2,
           dec_3,
           idx);


  input   clk;
  input   reset;
  input   enb;
  input   [1:0] acs_in_0;  // ufix2
  input   [1:0] acs_in_1;  // ufix2
  input   [1:0] acs_in_2;  // ufix2
  input   [1:0] acs_in_3;  // ufix2
  output  dec_0;  // ufix1
  output  dec_1;  // ufix1
  output  dec_2;  // ufix1
  output  dec_3;  // ufix1
  output  [1:0] idx;  // ufix2


  wire [1:0] acs_in [0:3];  // ufix2 [4]
  reg [1:0] syncnt;  // ufix2
  wire isCntLimit;  // ufix1
  wire synaccu;  // ufix1
  reg  dsyncaccu;  // ufix1
  wire stMetregEnb;
  reg [3:0] stMet [0:3];  // ufix4 [4]
  wire [3:0] nstMet_0;  // ufix4
  wire [3:0] nstMet_1;  // ufix4
  wire [3:0] nstMet_2;  // ufix4
  wire [3:0] nstMet_3;  // ufix4
  wire [3:0] nstMet [0:3];  // ufix4 [4]
  wire [3:0] bMet_normed [0:3];  // ufix4 [4]
  wire [3:0] normval;  // ufix4
  reg [3:0] dnormval;  // ufix4
  wire [3:0] BMet_adjustment_adders_1;  // ufix4
  wire [3:0] BMet_adjustment_adders_2;  // ufix4
  wire [3:0] BMet_adjustment_adders_3;  // ufix4
  wire [3:0] BMet_adjustment_adders_4;  // ufix4
  wire acsdec_0;  // ufix1
  wire acsdec_1;  // ufix1
  wire acsdec_2;  // ufix1
  wire acsdec_3;  // ufix1
  wire intdelay_out_1;  // ufix1
  reg  [0:3] intdelay_1_reg;  // ufix1 [4]
  wire intdelay_out_2;  // ufix1
  wire intdelay_out_3;  // ufix1
  wire intdelay_out_4;  // ufix1
  reg  [0:3] intdelay_1_reg_1;  // ufix1 [4]
  reg  [0:3] intdelay_1_reg_2;  // ufix1 [4]
  reg  [0:3] intdelay_1_reg_3;  // ufix1 [4]
  wire [0:3] intdelay_1_reg_next;  // ufix1 [4]
  wire [0:3] intdelay_1_reg_next_1;  // ufix1 [4]
  wire [0:3] intdelay_1_reg_next_2;  // ufix1 [4]
  wire [0:3] intdelay_1_reg_next_3;  // ufix1 [4]


  assign acs_in[0] = acs_in_0;
  assign acs_in[1] = acs_in_1;
  assign acs_in[2] = acs_in_2;
  assign acs_in[3] = acs_in_3;

  // Count limited, Unsigned Counter
  //  initial value   = 0
  //  step value      = 1
  //  count to value  = 2
  // Delays used to synchronize the state metric with valid branch metric data
  always @(posedge clk or posedge reset)
    begin : counter_process
      if (reset == 1'b1) begin
        syncnt <= 2'b00;
      end
      else begin
        if (enb) begin
          if (syncnt >= 2'b10) begin
            syncnt <= 2'b00;
          end
          else begin
            syncnt <= syncnt + 2'b01;
          end
        end
      end
    end



  assign isCntLimit = syncnt >= 2'b10;



  always @(posedge clk or posedge reset)
    begin : synaccuRegister_process
      if (reset == 1'b1) begin
        dsyncaccu <= 1'b0;
      end
      else begin
        if (enb) begin
          dsyncaccu <= synaccu;
        end
      end
    end



  assign synaccu = isCntLimit | dsyncaccu;



  assign stMetregEnb = synaccu > 1'b0;



  assign nstMet[0] = nstMet_0;
  assign nstMet[1] = nstMet_1;
  assign nstMet[2] = nstMet_2;
  assign nstMet[3] = nstMet_3;

  // State metric register
  always @(posedge clk or posedge reset)
    begin : stMetRegister_process
      if (reset == 1'b1) begin
        stMet[0] <= 4'b0000;
        stMet[1] <= 4'b0111;
        stMet[2] <= 4'b0111;
        stMet[3] <= 4'b0111;
      end
      else begin
        if (enb && stMetregEnb) begin
          stMet[0] <= nstMet[0];
          stMet[1] <= nstMet[1];
          stMet[2] <= nstMet[2];
          stMet[3] <= nstMet[3];
        end
      end
    end



  ACSRenorm u_ACSrenorm_inst (.clk(clk),
                              .reset(reset),
                              .enb(enb),
                              .stMet_0(nstMet_0),  // ufix4
                              .stMet_1(nstMet_1),  // ufix4
                              .stMet_2(nstMet_2),  // ufix4
                              .stMet_3(nstMet_3),  // ufix4
                              .normval(normval),  // ufix4
                              .idx(idx)  // ufix2
                              );

  always @(posedge clk or posedge reset)
    begin : NormvalRegister_process
      if (reset == 1'b1) begin
        dnormval <= 4'b0000;
      end
      else begin
        if (enb) begin
          dnormval <= normval;
        end
      end
    end



  // Branch Metric adjustment adders
  assign BMet_adjustment_adders_1 = {2'b0, acs_in[0]};
  assign bMet_normed[0] = BMet_adjustment_adders_1 + dnormval;
  assign BMet_adjustment_adders_2 = {2'b0, acs_in[1]};
  assign bMet_normed[1] = BMet_adjustment_adders_2 + dnormval;
  assign BMet_adjustment_adders_3 = {2'b0, acs_in[2]};
  assign bMet_normed[2] = BMet_adjustment_adders_3 + dnormval;
  assign BMet_adjustment_adders_4 = {2'b0, acs_in[3]};
  assign bMet_normed[3] = BMet_adjustment_adders_4 + dnormval;



  // ACS Unit Instantiation
  // Matching delay from Minimum tree
  ACSEngine u_ACSEngine (.branchMetric_0(bMet_normed[0]),  // ufix4
                         .branchMetric_1(bMet_normed[1]),  // ufix4
                         .branchMetric_2(bMet_normed[2]),  // ufix4
                         .branchMetric_3(bMet_normed[3]),  // ufix4
                         .stateMetric_0(stMet[0]),  // ufix4
                         .stateMetric_1(stMet[1]),  // ufix4
                         .stateMetric_2(stMet[2]),  // ufix4
                         .stateMetric_3(stMet[3]),  // ufix4
                         .acsDecision_0(acsdec_0),  // ufix1
                         .acsDecision_1(acsdec_1),  // ufix1
                         .acsDecision_2(acsdec_2),  // ufix1
                         .acsDecision_3(acsdec_3),  // ufix1
                         .nextStateMetric_0(nstMet_0),  // ufix4
                         .nextStateMetric_1(nstMet_1),  // ufix4
                         .nextStateMetric_2(nstMet_2),  // ufix4
                         .nextStateMetric_3(nstMet_3)  // ufix4
                         );

  always @(posedge clk or posedge reset)
    begin : intdelay_1_process
      if (reset == 1'b1) begin
        intdelay_1_reg[0] <= 1'b0;
        intdelay_1_reg[1] <= 1'b0;
        intdelay_1_reg[2] <= 1'b0;
        intdelay_1_reg[3] <= 1'b0;
        intdelay_1_reg_1[0] <= 1'b0;
        intdelay_1_reg_1[1] <= 1'b0;
        intdelay_1_reg_1[2] <= 1'b0;
        intdelay_1_reg_1[3] <= 1'b0;
        intdelay_1_reg_2[0] <= 1'b0;
        intdelay_1_reg_2[1] <= 1'b0;
        intdelay_1_reg_2[2] <= 1'b0;
        intdelay_1_reg_2[3] <= 1'b0;
        intdelay_1_reg_3[0] <= 1'b0;
        intdelay_1_reg_3[1] <= 1'b0;
        intdelay_1_reg_3[2] <= 1'b0;
        intdelay_1_reg_3[3] <= 1'b0;
      end
      else begin
        if (enb) begin
          intdelay_1_reg[0] <= intdelay_1_reg_next[0];
          intdelay_1_reg[1] <= intdelay_1_reg_next[1];
          intdelay_1_reg[2] <= intdelay_1_reg_next[2];
          intdelay_1_reg[3] <= intdelay_1_reg_next[3];
          intdelay_1_reg_1[0] <= intdelay_1_reg_next_1[0];
          intdelay_1_reg_1[1] <= intdelay_1_reg_next_1[1];
          intdelay_1_reg_1[2] <= intdelay_1_reg_next_1[2];
          intdelay_1_reg_1[3] <= intdelay_1_reg_next_1[3];
          intdelay_1_reg_2[0] <= intdelay_1_reg_next_2[0];
          intdelay_1_reg_2[1] <= intdelay_1_reg_next_2[1];
          intdelay_1_reg_2[2] <= intdelay_1_reg_next_2[2];
          intdelay_1_reg_2[3] <= intdelay_1_reg_next_2[3];
          intdelay_1_reg_3[0] <= intdelay_1_reg_next_3[0];
          intdelay_1_reg_3[1] <= intdelay_1_reg_next_3[1];
          intdelay_1_reg_3[2] <= intdelay_1_reg_next_3[2];
          intdelay_1_reg_3[3] <= intdelay_1_reg_next_3[3];
        end
      end
    end

  assign intdelay_1_reg_next[0] = acsdec_0;
  assign intdelay_1_reg_next[1] = intdelay_1_reg[0];
  assign intdelay_1_reg_next[2] = intdelay_1_reg[1];
  assign intdelay_1_reg_next[3] = intdelay_1_reg[2];
  assign intdelay_out_1 = intdelay_1_reg[3];
  assign intdelay_1_reg_next_1[0] = acsdec_1;
  assign intdelay_1_reg_next_1[1] = intdelay_1_reg_1[0];
  assign intdelay_1_reg_next_1[2] = intdelay_1_reg_1[1];
  assign intdelay_1_reg_next_1[3] = intdelay_1_reg_1[2];
  assign intdelay_out_2 = intdelay_1_reg_1[3];
  assign intdelay_1_reg_next_2[0] = acsdec_2;
  assign intdelay_1_reg_next_2[1] = intdelay_1_reg_2[0];
  assign intdelay_1_reg_next_2[2] = intdelay_1_reg_2[1];
  assign intdelay_1_reg_next_2[3] = intdelay_1_reg_2[2];
  assign intdelay_out_3 = intdelay_1_reg_2[3];
  assign intdelay_1_reg_next_3[0] = acsdec_3;
  assign intdelay_1_reg_next_3[1] = intdelay_1_reg_3[0];
  assign intdelay_1_reg_next_3[2] = intdelay_1_reg_3[1];
  assign intdelay_1_reg_next_3[3] = intdelay_1_reg_3[2];
  assign intdelay_out_4 = intdelay_1_reg_3[3];



  assign dec_0 = intdelay_out_1;

  assign dec_1 = intdelay_out_2;

  assign dec_2 = intdelay_out_3;

  assign dec_3 = intdelay_out_4;

endmodule  // ACS

