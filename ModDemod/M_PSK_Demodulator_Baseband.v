// -------------------------------------------------------------
// 
// File Name: C:\Users\TEMP\Desktop\mod\gm_untitled\M_PSK_Demodulator_Baseband.v
// Created: 2024-06-19 20:11:11
// 
// Generated by MATLAB 9.13 and HDL Coder 4.0
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: M_PSK_Demodulator_Baseband
// Source Path: gm_untitled/HDL_DUT/Subsystem/Subsystem/M-PSK Demodulator Baseband
// Hierarchy Level: 1
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module M_PSK_Demodulator_Baseband
          (in0_re,
           in0_im,
           out0_0,
           out0_1);


  input   signed [6:0] in0_re;  // sfix7_En6
  input   signed [6:0] in0_im;  // sfix7_En6
  output  out0_0;  // boolean
  output  out0_1;  // boolean


  wire inphase_lt_zero;
  wire inphase_eq_zero;
  wire quadrature_lt_zero;
  wire quadrature_eq_zero;
  wire [3:0] decisionLUTaddr;  // ufix4
  wire [1:0] DirectLookupTable_1 [0:15];  // ufix2 [16]
  wire [1:0] hardDecision;  // ufix2
  wire out0_part0;
  wire out0_part1;
  wire [0:1] out0_vector;  // boolean [2]
  wire [0:1] out0;  // boolean [2]


  assign inphase_lt_zero = in0_re < 7'sb0000000;



  assign inphase_eq_zero = in0_re == 7'sb0000000;



  assign quadrature_lt_zero = in0_im < 7'sb0000000;



  assign quadrature_eq_zero = in0_im == 7'sb0000000;



  assign decisionLUTaddr = {inphase_lt_zero, inphase_eq_zero, quadrature_lt_zero, quadrature_eq_zero};



  assign DirectLookupTable_1[0] = 2'b00;
  assign DirectLookupTable_1[1] = 2'b00;
  assign DirectLookupTable_1[2] = 2'b10;
  assign DirectLookupTable_1[3] = 2'b00;
  assign DirectLookupTable_1[4] = 2'b01;
  assign DirectLookupTable_1[5] = 2'b00;
  assign DirectLookupTable_1[6] = 2'b10;
  assign DirectLookupTable_1[7] = 2'b00;
  assign DirectLookupTable_1[8] = 2'b01;
  assign DirectLookupTable_1[9] = 2'b11;
  assign DirectLookupTable_1[10] = 2'b11;
  assign DirectLookupTable_1[11] = 2'b00;
  assign DirectLookupTable_1[12] = 2'b00;
  assign DirectLookupTable_1[13] = 2'b00;
  assign DirectLookupTable_1[14] = 2'b00;
  assign DirectLookupTable_1[15] = 2'b00;
  assign hardDecision = DirectLookupTable_1[decisionLUTaddr];



  assign out0_part0 = hardDecision[1];



  assign out0_part1 = hardDecision[0];



  assign out0_vector[0] = out0_part0;
  assign out0_vector[1] = out0_part1;

  assign out0[0] = (out0_vector[0] != 1'b0 ? 1'b1 :
              1'b0);
  assign out0[1] = (out0_vector[1] != 1'b0 ? 1'b1 :
              1'b0);



  assign out0_0 = out0[0];

  assign out0_1 = out0[1];

endmodule  // M_PSK_Demodulator_Baseband


module overflow_detect(in, out);
	input [7:0] in;
	output [6:0] out;
	
	assign out = ((in[7]&&in[6]) || (~in[7]&&~in[6]))?in[6:0]:(in[7]?7'b1000000:7'b0111111);

endmodule 