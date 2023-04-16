`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2023 11:51:55 PM
// Design Name: 
// Module Name: RegFile
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


module RegFile(
  rna, // read number a
  rda, // read data a
  rnb,
  rdb,
  we,  // write enable
  wn,  // write number
  wd,  // write data
  clk,
  rst_n
  );
  input[4:0] rna, rnb, wn;
  input clk, rst_n, we;
  output[31:0] rda, rdb, wd;
  reg [31:0] regs[1:31];

  integer i;
  
  assign rda = (rna == 0) ? 0 : regs[rna];
  assign rdb = (rnb == 0) ? 0 : regs[rnb];
  
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
      for(i = 1; i < 32; i = i + 1)
        regs[i] <= 0;
    end else if(we == 1 && wn != 0) begin
      regs[wn] <= wd;
    end
  end


endmodule
