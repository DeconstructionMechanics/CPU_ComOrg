`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 16:38:02
// Design Name: 
// Module Name: DataMem
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


module DataMem(
input ram_clk_i, // from CPU top
input[3:0] mode_i,
input [31:0] ram_adr_i, // from alu_result of ALU
input ram_wen_32_i,
input [31:0] ram_dat_32_i,
input ram_wen_128_i,
input [127:0] ram_dat_128_i,
output [31:0] ram_dat_32_o, // the data read from data-ram
output [127:0] ram_dat_128_o,
// UART Programmer Pinouts
input upg_rst_i, // UPG reset (Active High)
input upg_clk_i, // UPG ram_clk_i (10MHz)
input upg_wen_i, // UPG write enable
input [13:0] upg_adr_i, // UPG write address
input [31:0] upg_dat_i, // UPG write data
input upg_done_i // 1 if programming is finished
    );



wire ram_clk = !ram_clk_i;
wire upg_mode = ~upg_rst_i & ~upg_done_i;



mem_32_14  u_mem_32_14 (
    .clka                    ( upg_mode ? upg_clk_i : ram_clk  ),
    .wea                     ( upg_mode ? upg_wen_i : ram_wen_32_i     ),
    .addra                   ( upg_mode ? upg_adr_i : ram_adr_i[13:0]   ),
    .dina                    ( upg_mode ? upg_dat_i : ram_dat_32_i    ),
    .clkb                    ( upg_mode ? upg_clk_i : ram_clk    ),
    .enb                     ( upg_mode ? 1'b0 : 1'b1     ),
    .web                     ( upg_mode ? 1'b0 : ram_wen_128_i     ),
    .addrb                   ( upg_mode ? 12'd0 : ram_adr_i[11:0]   ),
    .dinb                    ( ram_dat_128_i    ),

    .douta                   ( ram_dat_32_o   ),
    .doutb                   ( ram_dat_128_o   )
);

endmodule
