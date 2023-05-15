`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 18:57:23
// Design Name: 
// Module Name: CtrlClk
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


module CtrlClk(
input fpga_clk_i,
input set_cnt_i,
output clk_o,
output[31:0] cycle_cnt_o,

input[3:0] exc_code_i,
output[3:0] mode_o
    );

wire clk;
assign clk_o = clk;
reg[31:0] cycle_cnt = 32'd0;
assign cycle_cnt_o = cycle_cnt;
reg[3:0] mode = 4'd4;
assign mode_o = mode;

Clk_10MHz  u_Clk_10MHz (
    .clk_in1                 ( fpga_clk_i    ),
    .clk_out1                ( clk   )
);

always @(posedge clk or posedge set_cnt_i) begin
    if(set_cnt_i)begin
        cycle_cnt <= 32'd0;
    end
    else if(mode == 4'd5) begin
        cycle_cnt <= cycle_cnt + 32'd1;
    end
end

always @(exc_code_i) begin
    if((exc_code_i == 4'd2 && mode != 4'd6))begin
        mode <= 4'd2;
    end
    else if((exc_code_i == 4'd4 && mode != 4'd2 && mode != 4'd6))begin
        mode <= 4'd4;
    end
    else if((exc_code_i == 4'd1 && mode != 4'd6) || (exc_code_i == 4'd3 && mode != 4'd2 && mode != 4'd6) || (exc_code_i == 4'd6 && mode != 4'd2 && mode != 4'd4))begin
        mode <= 4'd5;
    end
    else if((exc_code_i == 4'd5))begin
        mode <= 4'd6;
    end
    else begin
        mode <= mode;
    end
end

endmodule
