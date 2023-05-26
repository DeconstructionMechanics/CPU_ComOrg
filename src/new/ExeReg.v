`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/11 08:54:25
// Design Name: 
// Module Name: ExeReg
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


module ExeReg(
input clk_i,
input[3:0] mode_i,
input reset_i,

input[31:0] data_load_32_i,
input[127:0] data_load_128_i,

input[31:0] pc_plus4_i,
input[31:0] instruction_i,

input[31:0] cycle_cnt_i,
input[31:0] IO_i,
input[4:0] keyboard_val_i,

output[3:0] exc_code_o,
output[31:0] data_addr_o,
output data_wen_32_o,
output[31:0] data_store_32_o,
output data_wen_128_o,
output[127:0] data_store_128_o,

output j_valid_o,
output[25:0] j_addr_o,
output b_valid_o,
output[15:0] b_addr_o,

output set_cnt_o,
output IO_able_o,
output[31:0] IO_o,


//
output[31:0] hi_o,
output[31:0] lo_o
    );

reg [31:0] reg_32 [0:31];
reg [31:0] hi = 32'd0;
reg [31:0] lo = 32'd0;
reg [127:0] add1 = 128'd0;
reg [127:0] add2 = 128'd0;
reg [127:0] add_r = 128'd0;

reg [31:0] next_hi = 32'd0;
reg [31:0] next_lo = 32'd0;
assign hi_o = hi;
assign lo_o = lo;

wire[5:0] opcode = instruction_i[31:26];
wire[4:0] rs = instruction_i[25:21];
wire[4:0] rt = instruction_i[20:16];
wire[4:0] rd = instruction_i[15:11];
wire[4:0] shamt = instruction_i[10:6];
wire[5:0] funct = instruction_i[5:0];
wire[15:0] immediate = instruction_i[15:0];
wire[25:0] address = instruction_i[25:0];


reg [25:0] j_addr = 26'd0;
assign j_addr_o = j_addr;
assign j_valid_o = (mode_i == 4'd5) & ((funct == 6'b001100 & reg_32[2] == 32'd15 & reg_32[4][14])|(funct == 6'b001101 & rt[4])|(funct == 6'b001100 & reg_32[2] == 32'd10)|((opcode == 6'd0) & (funct == 6'b001000))|(opcode == 6'b000010)|(opcode == 6'b000011));

reg [15:0] b_addr = 16'd0;
reg b_cond = 1'b0;
assign b_addr_o = b_addr;
assign b_valid_o = (mode_i == 4'd5) & ((opcode == 6'b000100) | (opcode == 6'b000101)) & b_cond;

reg [31:0] data_addr = 32'd0;
reg [4:0] to_load = 5'b0;
reg [4:0] to_store = 5'b0;
reg be_store = 1'b0;
reg data_wen_32 = 1'b0;
assign data_addr_o = data_addr;
assign data_wen_32_o = data_wen_32;
assign data_store_32_o = reg_32[to_store];

reg IO_able = 1'b0;
assign IO_able_o = IO_able;
assign IO_o = reg_32[4];

reg simd_load = 1'b0;
assign data_store_128_o = add_r;
reg simd_store = 1'b0;
reg data_wen_128 = 1'b0;
assign data_wen_128_o = data_wen_128;

reg cycle_reset = 1'b0;
assign set_cnt_o = cycle_reset;

reg [3:0] exc_code = 4'd0;
assign exc_code_o = exc_code;


reg[4:0] wb_index = 5'd0;
reg[31:0] wb_data = 32'h00000000;


always @(posedge clk_i)begin
    if(mode_i == 4'd5 && opcode == 6'd0)begin //R-format
        case (funct)
            6'b000000:begin //sll
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= reg_32[rt] << shamt;
                end
            6'b000010:begin //srl
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= reg_32[rt] >> shamt;
                end
            6'b000100:begin //sllv
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= reg_32[rt] << reg_32[rs];
                end
            6'b000110:begin //srlv
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= reg_32[rt] >> reg_32[rs];
                end
            6'b000011:begin //sra
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= $signed(reg_32[rt]) >> shamt;
                end
            6'b000111:begin //srav
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= $signed(reg_32[rt]) >> reg_32[rs];
                end
            6'b001000:begin //jr
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= 5'd0;
                    j_addr <= reg_32[rs][25:0];// - 26'd2;
                end
            6'b010000:begin //mfhi
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= hi;
                end
            6'b010010:begin //mflo
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= lo;
                end
            6'b011000:begin //mult
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= 5'd0;
                    {next_hi,next_lo} <= $signed(reg_32[rt]) * $signed(reg_32[rs]);
                end
            6'b011001:begin //multu
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= 5'd0;
                    {next_hi,next_lo} <= (reg_32[rt]) * (reg_32[rs]);
                end
            6'b011000:begin //div
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= 5'd0;
                    next_lo <= $signed(reg_32[rs]) / $signed(reg_32[rt]);
                    next_hi <= $signed(reg_32[rs]) % $signed(reg_32[rt]);
                    exc_code <= (reg_32[rt] == 32'd0)? 4'd2 : 4'd0;
                end
            6'b011001:begin //divu
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= 5'd0;
                    next_lo <= (reg_32[rs]) / (reg_32[rt]);
                    next_hi <= (reg_32[rs]) % (reg_32[rt]);
                    exc_code <= (reg_32[rt] == 32'd0)? 4'd2 : 4'd0;
                end
            6'b100000:begin //add
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= $signed(reg_32[rt]) + $signed(reg_32[rs]);
                end
            6'b100001:begin //addu
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= (reg_32[rt]) + (reg_32[rs]);
                end
            6'b100010:begin //sub
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= $signed(reg_32[rs]) - $signed(reg_32[rt]);
                end
            6'b100011:begin //subu
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= (reg_32[rs]) - (reg_32[rt]);
                end
            6'b100100:begin //and
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= (reg_32[rs]) & (reg_32[rt]);
                end
            6'b100101:begin //or
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= (reg_32[rs]) | (reg_32[rt]);
                end
            6'b100110:begin //xor
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= (reg_32[rs]) ^ (reg_32[rt]);
                end
            6'b100111:begin //nor
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data <= ~(reg_32[rs] | reg_32[rt]);
                end
            6'b101010:begin //slt
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data[31:1] <= 31'd0;
                    wb_data[0] <= $signed(reg_32[rs]) < $signed(reg_32[rt]);
                end
            6'b101011:begin //sltu
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rd;
                    wb_data[31:1] <= 31'd0;
                    wb_data[0] <= (reg_32[rs] < reg_32[rt]);
                end

            6'b001100:begin //syscall
                    case (reg_32[2])
                        32'd1:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                exc_code <= 4'd0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;
                                wb_index <= 5'd0;
                                
                                IO_able <= 1'b1;
                            end
                        32'd5:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                IO_able <= 1'b0;
                                exc_code <= 4'd0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;

                                wb_index <= 5'd2;
                                wb_data <= IO_i;
                            end
                        32'd8:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                IO_able <= 1'b0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;

                                wb_index <= 5'd2;
                                wb_data <= {27'd0,keyboard_val_i};
                            end
                        32'd10:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                IO_able <= 1'b0;
                                exc_code <= 4'd0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;
                                wb_index <= 5'd0;

                                j_addr <= 26'd0;
                                exc_code <= 4'd4;
                            end
                        32'd11:begin
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                IO_able <= 1'b0;
                                exc_code <= 4'd0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;
                                wb_index <= 5'd0;

                                data_addr <= reg_32[4];
                                simd_load <= 1'b1;
                            end
                        32'd12:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                IO_able <= 1'b0;
                                exc_code <= 4'd0;
                                data_wen_32 <= 1'b0;
                                wb_index <= 5'd0;

                                data_addr <= reg_32[4];
                                add_r[127:96] <= add1[127:96] + add2[127:96];
                                add_r[95:64] <= add1[95:64] + add2[95:64];
                                add_r[63:32] <= add1[63:32] + add2[63:32];
                                add_r[31:0] <= add1[31:0] + add2[31:0];
                                data_wen_128 <= 1'b1;
                            end
                        32'd13:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                IO_able <= 1'b0;
                                exc_code <= 4'd0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;

                                wb_index <= 5'd2;
                                wb_data <= cycle_cnt_i;
                            end
                        32'd14:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                IO_able <= 1'b0;
                                exc_code <= 4'd0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;
                                wb_index <= 5'd0;

                                cycle_reset <= 1'b1;
                            end
                        32'd15:begin
                                simd_load <= 1'b0;
                                to_load <= 5'd0;
                                cycle_reset <= 1'b0;
                                IO_able <= 1'b0;
                                data_wen_32 <= 1'b0;
                                data_wen_128 <= 1'b0;
                                
                                if(reg_32[4][14])begin
                                    exc_code <= 4'd0;

                                    wb_index <= 5'd31;
                                    j_addr <= reg_32[4][25:0];
                                    wb_data <= pc_plus4_i;
                                end
                                else begin
                                    wb_index <= 5'd0;
                                    exc_code <= reg_32[4][3:0];
                                end
                            end
                    endcase
                end
            6'b001101:begin //break
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;
                    
                    if(rt[4])begin
                        exc_code <= 4'd0;

                        wb_index <= 5'd31;
                        j_addr <= {instruction_i[31:6]};
                        wb_data <= pc_plus4_i;
                    end
                    else begin
                        wb_index <= 5'd0;
                        exc_code <= shamt[3:0];
                    end
                end
        endcase
    end
    else if(mode_i == 4'd5)begin // other format
        case (opcode)
            6'b000100:begin //beq
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;
                    wb_index <= 5'd0;

                    b_cond <= (reg_32[rs] == reg_32[rt]);
                    b_addr <= immediate;
                end
            6'b000101:begin //bne
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;
                    wb_index <= 5'd0;

                    b_cond <= (reg_32[rs] != reg_32[rt]);
                    b_addr <= immediate;
                end
            6'b100011:begin //lw
                    simd_load <= 1'b0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;
                    wb_index <= 5'd0;

                    data_addr <= $signed(reg_32[rs]) + $signed({{16{immediate[15]}},immediate});
                    to_load <= rt;
                end
            6'b101011:begin //sw
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_128 <= 1'b0;
                    wb_index <= 5'd0;

                    data_addr <= $signed(reg_32[rs]) + $signed({{16{immediate[15]}},immediate});
                    to_store <= rt;
                    data_wen_32 <= 1'b1;
                end
            6'b001000:begin //addi
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data <= $signed(reg_32[rs]) + $signed({{16{immediate[15]}},immediate});
                end
            6'b001001:begin //addiu
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data <= reg_32[rs] + {16'd0,immediate};
                end
            6'b001010:begin //slti
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data[31:1] <= 31'd0;
                    wb_data[0] <= $signed(reg_32[rs]) < $signed({{16{immediate[15]}},immediate});
                end
            6'b001011:begin //sltiu
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data[31:1] <= 31'd0;
                    wb_data[0] <= (reg_32[rs]) < {16'd0,immediate};
                end
            6'b001100:begin //andi
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data <= reg_32[rs] & {16'd0,immediate};
                end
            6'b001101:begin //ori
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data <= reg_32[rs] | {16'd0,immediate};
                end
            6'b001110:begin //xori
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data <= reg_32[rs] ^ {16'd0,immediate};
                end
            6'b001111:begin //lui
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= rt;
                    wb_data[31:16] <= immediate;
                    wb_data[15:0] <= 16'd0;
                end
            6'b000010:begin //j
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;
                    wb_index <= 5'd0;

                    j_addr <= address;
                end
            6'b000011:begin //jal
                    simd_load <= 1'b0;
                    to_load <= 5'd0;
                    cycle_reset <= 1'b0;
                    IO_able <= 1'b0;
                    exc_code <= 4'd0;
                    data_wen_32 <= 1'b0;
                    data_wen_128 <= 1'b0;

                    wb_index <= 5'd31;
                    j_addr <= address;
                    wb_data <= pc_plus4_i;
                end
        endcase
    end
end

integer i;

always @(negedge clk_i)begin
    if(reset_i)begin
        for (i = 0; i < 29; i = i + 1) begin
            reg_32[i] <= 32'd0;
        end
        reg_32[29] <= 32'hfffff000;
        reg_32[30] <= 32'h00000000;
        reg_32[31] <= 32'h00000000;
    end
    else if(to_load != 5'd0 && to_load < 5'd28)begin
        reg_32[to_load] <= data_load_32_i;
    end
    else if(wb_index != 5'd0)begin
        reg_32[wb_index] <= wb_data;
    end

    if(reset_i)begin
        add1 <= 128'd0;
        add2 <= 128'd0;
    end
    else if(simd_load && reg_32[5])begin
        add1 <= data_load_128_i;
    end
    else if(simd_load && ~reg_32[5])begin
        add2 <= data_load_128_i;
    end

    lo <= next_lo;
    hi <= next_hi;
end


endmodule
