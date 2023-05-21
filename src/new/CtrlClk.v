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
input btn_rst_i,
input btn_err_i,
input btn_pause_i,
input btn_continue_i,
input btn_uart_i,
output[3:0] mode_o
    );

wire clk;
assign clk_o = clk;
reg[31:0] cycle_cnt = 32'd0;
assign cycle_cnt_o = cycle_cnt;
reg[3:0] mode = 4'd4;
reg[3:0] next_mode = 4'd4;
assign mode_o = mode;

Clk_10MHz  u_Clk_10MHz (
    .clk_in1                 ( fpga_clk_i    ),
    .clk_out1                ( clk   )
);

always @(negedge clk)begin
    if(set_cnt_i)begin
        cycle_cnt <= 32'd0;
    end
    else if(mode == 4'd5) begin
        cycle_cnt <= cycle_cnt + 32'd1;
    end
end

always @(negedge clk)begin
    mode <= next_mode;
end


always @(*) begin
    if(btn_uart_i)begin
        next_mode <= 4'd6;
    end
    else if(btn_uart_i)begin
        next_mode <= 4'd5;
    end
    else if(btn_rst_i && mode != 4'd6)begin
        next_mode <= 4'd5;
    end
    else if(btn_err_i && mode != 4'd6)begin
        next_mode <= 4'd2;
    end
    else if(btn_pause_i && mode != 4'd6 && mode != 4'd2)begin
        next_mode <= 4'd4;
    end
    else if(btn_continue_i && (mode == 4'd4 || mode == 4'd6))begin
        next_mode <= 4'd5;
    end

    else if((exc_code_i == 4'd2 && mode != 4'd6))begin
        next_mode <= 4'd2;
    end
    else if((exc_code_i == 4'd4 && mode != 4'd2 && mode != 4'd6))begin
        next_mode <= 4'd4;
    end
    else if((exc_code_i == 4'd1 && mode != 4'd6) || (exc_code_i == 4'd3 && mode != 4'd2 && mode != 4'd6) || (exc_code_i == 4'd6 && mode != 4'd2 && mode != 4'd4))begin
        next_mode <= 4'd5;
    end
    else if((exc_code_i == 4'd5))begin
        next_mode <= 4'd6;
    end
    else begin
        next_mode <= mode;
    end
end

endmodule
