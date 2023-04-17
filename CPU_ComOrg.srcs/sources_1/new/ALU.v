`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 10:00:09 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU (
  dina,     // data input a
  dinb,     // data input b
  aluc,     // ALU control
  r,        // return value
  z         // zero
);
  input[31:0] dina, dinb;
  input[3:0] aluc;
  output[31:0] r;
  output z;
  
  wire[32:0] r_add = dina + dinb;   // add, addi
  wire[32:0] r_minus = dina - dinb; // sub, subi, beq, bnq
  wire[31:0] r_and = dina & dinb;   // and
  wire[31:0] r_or = dina | dinb;    // or
  wire[31:0] r_xor = dina ^ dinb;   // xor
  wire[31:0] r_lui = {dinb[15:0], 16'b0};
  
  always @(*) begin
    case (aluc)
      
    endcase
  end


endmodule
