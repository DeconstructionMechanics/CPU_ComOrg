`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 16:37:17
// Design Name: 
// Module Name: IFetch
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


module IFetch(
input clk_i,
input[3:0] mode_i, // CPU mode
input reset_i,
input j_valid_i,
input[25:0] j_addr_i,
input b_valid_i,
input[15:0] b_addr_i,

output[31:0] pc_plus4_o,
output[31:0] instruction_o, 
// UART Programmer Pinouts
input upg_rst_i, // UPG reset (Active High)
input upg_clk_i, // UPG clock (10MHz)
input upg_wen_i, // UPG write enable
input[13:0] upg_adr_i, // UPG write address
input[31:0] upg_dat_i, // UPG write data
input upg_done_i
    );


wire upg_mode = ~upg_rst_i & ~upg_done_i;

reg[31:0] pc = 32'd0;
wire[31:0] pc_plus4 = pc + 32'd1;
assign pc_plus4_o = pc_plus4;

always @(negedge clk_i) begin
    if(pc_plus4[15:0] > 16'h1fff || mode_i == 4'd6 || reset_i)begin
        pc <= 32'd0;
    end
    else if(j_valid_i)begin
        pc[25:0] <= j_addr_i;
    end
    else if(mode_i == 4'd5 && b_valid_i)begin
        pc[15:0] <= $signed(pc_plus4[15:0]) + $signed(b_addr_i);
    end
    else if(mode_i == 4'd5)begin
        pc <= pc_plus4;
    end
end


text_32_14  u_text_32_14 (
    .clka                    ( upg_mode ? upg_clk_i : clk_i    ),
    .wea                     ( upg_mode ? upg_wen_i : 1'b0     ),
    .addra                   ( upg_mode ? upg_adr_i : pc[13:0] ),
    .dina                    ( upg_mode ? upg_dat_i : 32'd0    ),

    .douta                   ( instruction_o   ) 
);

endmodule
