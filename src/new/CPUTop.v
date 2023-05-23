`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/08 15:23:49
// Design Name: 
// Module Name: CPUTop
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


module CPUTop(
    input btn_rst,
    input btn_err,
    input btn_pause,
    input btn_continue,
    input btn_uart,
    
    input fpga_clk,
    input[23:0] switch_24,
    input[3:0] keyboard_row,
    output[3:0] keyboard_col,
    
    input rx,
    output tx,

    output[23:0] led_24
    );
    
// clk and control unit
wire clk;
wire set_cnt;
wire[31:0] cycle_cnt;
wire[3:0] exc_code;
wire[3:0] mode;

reg reset = 1'd1;
always @(posedge clk)begin
    if(exc_code == 4'd1 | btn_rst | btn_uart)begin
        reset <= 1'd1;
    end
    else begin
        reset <= 1'd0;
    end
end
CtrlClk  u_CtrlClk (
    .fpga_clk_i              ( fpga_clk    ),
    .set_cnt_i               ( set_cnt     ),
    .switch_i                (switch_24[23]),
    .exc_code_i              ( exc_code    ),
    .btn_rst_i               (btn_rst),
    .btn_err_i               (btn_err),
    .btn_pause_i             (btn_pause),
    .btn_continue_i          (btn_continue),
    .btn_uart_i              (btn_uart),

    .clk_o                   ( clk         ),
    .cycle_cnt_o             ( cycle_cnt   ),
    .mode_o                  ( mode        ) 
);


// uart program
wire upg_clk_o;
wire upg_wen_o;
wire [14:0] upg_adr_o;
wire [31:0] upg_dat_o;
wire upg_done_o;

reg upg_rst;
always @(mode or upg_done_o)begin
    if(upg_done_o)begin
        upg_rst <= 1'd1;
    end
    else if(mode == 4'd6)begin
        upg_rst <= 1'b0;
    end
    else begin
        upg_rst <= 1'b1;
    end
end

uart_bmpg_0  u_uart_bmpg_0 (
    .upg_clk_i               ( clk    ),
    .upg_rst_i               ( upg_rst    ),
    .upg_rx_i                ( rx     ),

    .upg_clk_o               ( upg_clk_o    ),
    .upg_wen_o               ( upg_wen_o    ),
    .upg_adr_o               ( upg_adr_o    ),
    .upg_dat_o               ( upg_dat_o    ),
    .upg_done_o              ( upg_done_o   ),
    .upg_tx_o                ( tx     ) 
);


//data memory
wire[31:0] data_addr;
wire data_wen_32;
wire[31:0] data_store_32;
wire data_wen_128;
wire[127:0] data_store_128;
wire[31:0] data_load_32;
wire[127:0] data_load_128;

DataMem  u_DataMem (
    .ram_clk_i               ( fpga_clk       ),
    .mode_i                  ( mode          ),
    .ram_adr_i               ( data_addr       ),
    .ram_wen_32_i            ( data_wen_32    ),
    .ram_dat_32_i            ( data_store_32    ),
    .ram_wen_128_i           ( data_wen_128   ),
    .ram_dat_128_i           ( data_store_128   ),
    .upg_rst_i               ( upg_rst      ),
    .upg_clk_i               ( upg_clk_o       ),
    .upg_wen_i               ( upg_wen_o & upg_adr_o[14]   ),
    .upg_adr_i               ( upg_adr_o[13:0]       ),
    .upg_dat_i               ( upg_dat_o       ),
    .upg_done_i              ( upg_done_o     ),

    .ram_dat_32_o            ( data_load_32    ),
    .ram_dat_128_o           ( data_load_128   )
);

//instruction fetch
wire j_valid;
wire[25:0] j_addr;
wire b_valid;
wire[15:0] b_addr;
wire[31:0] pc_plus4;
wire[31:0] instruction;

IFetch  u_IFetch (
    .clk_i                   ( clk           ),
    .fpga_clk_i              (fpga_clk),
    .mode_i                  ( mode          ),
    .reset_i                 (reset),
    .j_valid_i               ( j_valid       ),
    .j_addr_i                ( j_addr        ),
    .b_valid_i               ( b_valid       ),
    .b_addr_i                ( b_addr        ),
    .upg_rst_i               ( upg_rst       ),
    .upg_clk_i               ( upg_clk_o       ),
    .upg_wen_i               ( upg_wen_o & (!upg_adr_o[14])       ),
    .upg_adr_i               ( upg_adr_o[13:0]       ),
    .upg_dat_i               ( upg_dat_o       ),
    .upg_done_i              ( upg_done_o      ),

    .pc_plus4_o              ( pc_plus4      ),
    .instruction_o           ( instruction   )
);

wire[31:0] IO2led;
wire[31:0] IO2cpu;
wire IO_able_o;

wire [3:0] keyboard_val;

ExeReg  u_ExeReg (
    .clk_i                   ( clk              ),
    .mode_i                  ( mode             ),
    .reset_i                 (reset),
    .data_load_32_i          ( data_load_32     ),
    .data_load_128_i         ( data_load_128    ),
    .pc_plus4_i              ( pc_plus4         ),
    .instruction_i           ( instruction      ),
    .cycle_cnt_i             (cycle_cnt),
    .IO_i                    ( IO2cpu),
    .keyboard_val_i          (keyboard_val),

    .exc_code_o              ( exc_code      ),
    .data_addr_o             ( data_addr        ),
    .data_wen_32_o           ( data_wen_32      ),
    .data_store_32_o         ( data_store_32    ),
    .data_wen_128_o          ( data_wen_128     ),
    .data_store_128_o        ( data_store_128   ),
    .j_valid_o               ( j_valid          ),
    .j_addr_o                ( j_addr           ),
    .b_valid_o               ( b_valid          ),
    .b_addr_o                ( b_addr           ),
    .set_cnt_o               (set_cnt),
    .IO_able_o               (IO_able_o),
    .IO_o                    ( IO2led)
);



OIface  u_OIface (
    .clk_i                   (clk),
    .switch_24_i             ( switch_24      ),
    .keyboard_val_i          (keyboard_val),
    .IO_able_i               (IO_able_o),
    .IO2led_i                ( IO2led         ),
    .exc_code_i              (exc_code),
    .mode_i                  (mode), 
    .reset_i                 (reset),    

    .upg_rst_i               (upg_rst),
    .upg_rx_i                (rx),
    .upg_wen_i               (upg_wen_o),
    .upg_done_i              (upg_done_o),
    .pc_plus4_i              (pc_plus4),
    .instruction_i           (instruction),  

    .led_24_o                ( led_24         ),
    .IO2cpu_o                ( IO2cpu         ) 
);

Keyboard #(
    .NO_KEY_PRESSED ( 6'b000_001 ),
    .SCAN_COL0      ( 6'b000_010 ),
    .SCAN_COL1      ( 6'b000_100 ),
    .SCAN_COL2      ( 6'b001_000 ),
    .SCAN_COL3      ( 6'b010_000 ),
    .KEY_PRESSED    ( 6'b100_000 ))
 u_Keyboard (
    .clk                     ( fpga_clk            ),
    .rst                     ( reset            ),
    .row                     ( keyboard_row            ),

    .col                     ( keyboard_col            ),
    .keyboard_val            ( keyboard_val   ) 
);


endmodule



