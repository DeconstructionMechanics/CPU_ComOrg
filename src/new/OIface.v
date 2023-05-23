`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/11 14:54:35
// Design Name: 
// Module Name: OIface
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


module OIface(
    input clk_i,
    input[23:0] switch_24_i,
    input[3:0] keyboard_val_i,
    output[23:0] led_24_o,

    input[3:0] exc_code_i,
    input[3:0] mode_i,
    input reset_i,
    input IO_able_i,
    input[31:0] IO2led_i,
    output[31:0] IO2cpu_o,

    input upg_rst_i,
    input upg_rx_i,
    input upg_wen_i,
    input upg_done_i,
    input[31:0] pc_plus4_i,
    input[31:0] instruction_i
    );

reg[31:0] led_buffer = 32'd0;

reg buffer_valid = 1'b0;
reg buffer_valid_next = 1'b0;
always @(posedge clk_i)begin
    buffer_valid <= buffer_valid_next;
end
always @(negedge clk_i)begin  //mode_i or IO_able_i or reset_i
    if(mode_i == 4'd2)begin
        led_buffer <= 32'hffffffff;
        buffer_valid_next <= 1'b0;
    end
    else if(reset_i)begin
        led_buffer <= 32'd0;
        buffer_valid_next <= 1'b0;
    end
    else if(mode_i == 4'd6)begin
        led_buffer <= {28'd0,upg_rst_i,upg_rx_i,upg_wen_i,upg_done_i};
        buffer_valid_next <= 1'b0;
    end
    else if(IO_able_i)begin
        led_buffer <= IO2led_i;
        buffer_valid_next <= 1'b1;
    end
    else if(!buffer_valid) begin
        led_buffer <= 32'd0;
    end
end


reg[31:0] switch_buffer;
assign IO2cpu_o = switch_buffer;

always @(*) begin
    switch_buffer <= {8'd0,switch_24_i};
end

assign led_24_o = (switch_24_i[23]) ? {clk_i,mode_i[2:0],(pc_plus4_i[7:0] - 8'd1),instruction_i[31:26],instruction_i[5:0]} : {mode_i,led_buffer[19:0]};

endmodule
