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
    input[23:0] switch_24_i,
    input[3:0] keyboard_row_i,
    input[3:0] keyboard_col_i,
    output[23:0] led_24_o,

    input[3:0] mode_i,
    input IO_able_i,
    input[31:0] IO2led_i,
    output[31:0] IO2cpu_o
    );

reg[31:0] led_buffer = 32'd0;
assign led_24_o[23:20] = mode_i;
assign led_24_o[19:0] = led_buffer[19:0];

reg buffer_valid = 1'b1;
always @(mode_i or IO_able_i)begin
    if(mode_i == 4'd2)begin
        led_buffer = 32'hffffffff;
        buffer_valid = 1'b0;
    end
    else if(IO_able_i)begin
        led_buffer = IO2led_i;
        buffer_valid = 1'b1;
    end
    else if(~buffer_valid) begin
        led_buffer = 32'd0;
    end
    else begin
        led_buffer = led_buffer;
    end
end


reg[31:0] switch_buffer;
assign IO2cpu_o = switch_buffer;
reg[3:0] keyboard_value = 4'd0;
always @(keyboard_row_i or keyboard_col_i)begin
    case (keyboard_row_i)
        4'b0001:
        case (keyboard_col_i)
            4'b0001: keyboard_value <= 4'd1;
            4'b0010: keyboard_value <= 4'd2;
            4'b0100: keyboard_value <= 4'd3;
            4'b1000: keyboard_value <= 4'd10;
        endcase
        4'b0010:
        case (keyboard_col_i)
            4'b0001: keyboard_value <= 4'd4;
            4'b0010: keyboard_value <= 4'd5;
            4'b0100: keyboard_value <= 4'd6;
            4'b1000: keyboard_value <= 4'd11;
        endcase
        4'b0100:
        case (keyboard_col_i)
            4'b0001: keyboard_value <= 4'd7;
            4'b0010: keyboard_value <= 4'd8;
            4'b0100: keyboard_value <= 4'd9;
            4'b1000: keyboard_value <= 4'd12;
        endcase
        4'b1000:
        case (keyboard_col_i)
            4'b0001: keyboard_value <= 4'd14;
            4'b0010: keyboard_value <= 4'd0;
            4'b0100: keyboard_value <= 4'd15;
            4'b1000: keyboard_value <= 4'd13;
        endcase
    endcase
end
reg valid_flag = 0; // 0 switch; 1 keyboard
reg [3:0] prev_keyboard_value = 4'd0;

always @(keyboard_value,switch_24_i) begin
    if (keyboard_value != prev_keyboard_value) begin
        valid_flag <= 1;
        prev_keyboard_value <= keyboard_value;
    end
    else begin
        valid_flag <= 0;
    end
end
always @(*)begin
    switch_buffer = valid_flag? {28'd0,keyboard_value} : {8'd0,switch_24_i};
end

endmodule
