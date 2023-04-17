`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 10:00:09 PM
// Design Name: 
// Module Name: Controller
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


module Controller(
  op,       // op from IFetch
  func,     // func from IFetch
  z,        // zero from ALU, +ve if zero
  pcsource, // mulplex to choose pc. 
            // 0: PC+4; 1: PC relative; 2: Base; 3: Pseudo
  aluc,     // alu control
  wreg,     // enable to write register
  wmem,     // write memory
  jal,      // if jump and link
  );

  input [5:0] op, func;
  input z;
  output[3:0] aluc;
  output[1:0] pcsource;
  output wreg, wmem, jal;
  
  


endmodule
