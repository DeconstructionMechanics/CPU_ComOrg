`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 10:03:16 PM
// Design Name: 
// Module Name: Dmem
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


module Dmem (
    clk,
    addr,
    wea,  // write_enable
    wd,   // write_data
    rd    // read_data
);

  input clk;
  input [31:0] addr;
  input wea;
  input [31:0] wd;
  output [31:0] rd;


  wire clk_n;
  assign clk_n = !clk;

  RAM ram (
      .addra(addr[15:2]),
      .clka (clk_n),
      .wea  (wea),
      .dina (wd),
      .douta(rd)
  );

endmodule

