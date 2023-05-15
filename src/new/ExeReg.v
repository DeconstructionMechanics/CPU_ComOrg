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

input[31:0] data_load_32_i,
input[127:0] data_load_128_i,

input[31:0] pc_plus4_i,
input[31:0] instruction_i,

input[31:0] cycle_cnt_i,
input[31:0] IO_i,

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
output[31:0] IO_o
    );

reg [31:0] reg_32 [0:31];
reg [31:0] hi = 32'd0;
reg [31:0] lo = 32'd0;
reg [127:0] add1 = 128'd0;
reg [127:0] add2 = 128'd0;
reg [127:0] add_r = 128'd0;

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
assign j_valid_o = (mode_i == 4'd5) & (((opcode == 6'd0) & (funct == 6'b001000))|(opcode == 6'b000010)|(opcode == 6'b000011));

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

initial begin
    reg_32[0] = 32'h00000000;
    reg_32[29] = 32'h00003fff;
    reg_32[31] = 32'h00000000;
end

always @(clk_i)begin
    reg_32[0] = 32'h00000000;
    data_wen_32 = 1'b0;
    data_wen_128 = 1'b0;
    if(mode_i == 4'd5 && clk_i && opcode == 6'd0)begin //R-format
        case (funct)
            6'b000000:begin //sll
                    reg_32[rd] = reg_32[rt] << shamt;
                end
            6'b000010:begin //srl
                    reg_32[rd] = reg_32[rt] >> shamt;
                end
            6'b000100:begin //sllv
                    reg_32[rd] = reg_32[rt] << reg_32[rs];
                end
            6'b000110:begin //srlv
                    reg_32[rd] = reg_32[rt] >> reg_32[rs];
                end
            6'b000011:begin //sra
                    reg_32[rd] = $signed(reg_32[rt]) >> shamt;
                end
            6'b000111:begin //srav
                    reg_32[rd] = $signed(reg_32[rt]) >> reg_32[rs];
                end
            6'b001000:begin //jr
                    j_addr = reg_32[rs][25:0];
                end
            6'b010000:begin //mfhi
                    reg_32[rd] = hi;
                end
            6'b010010:begin //mflo
                    reg_32[rd] = lo;
                end
            6'b011000:begin //mult
                    {hi,lo} = $signed(reg_32[rt]) * $signed(reg_32[rs]);
                end
            6'b011001:begin //multu
                    {hi,lo} = (reg_32[rt]) * (reg_32[rs]);
                end
            6'b100000:begin //add
                    reg_32[rd] = $signed(reg_32[rt]) + $signed(reg_32[rs]);
                end
            6'b100001:begin //addu
                    reg_32[rd] = (reg_32[rt]) + (reg_32[rs]);
                end
            6'b100010:begin //sub
                    reg_32[rd] = $signed(reg_32[rs]) - $signed(reg_32[rt]);
                end
            6'b100011:begin //subu
                    reg_32[rd] = (reg_32[rs]) - (reg_32[rt]);
                end
            6'b100100:begin //and
                    reg_32[rd] = (reg_32[rs]) & (reg_32[rt]);
                end
            6'b100101:begin //or
                    reg_32[rd] = (reg_32[rs]) | (reg_32[rt]);
                end
            6'b100110:begin //xor
                    reg_32[rd] = (reg_32[rs]) ^ (reg_32[rt]);
                end
            6'b100111:begin //nor
                    reg_32[rd] = ~(reg_32[rs] | reg_32[rt]);
                end
            6'b101010:begin //slt
                    reg_32[rd][0] = (reg_32[rs] < reg_32[rt]);
                end
            6'b101011:begin //sltu
                    reg_32[rd][0] = $signed(reg_32[rs]) < $signed(reg_32[rt]);
                end

            6'b001100:begin //syscall
                    case (reg_32[2])
                        32'd1:begin
                                IO_able = 1'b1;
                            end
                        32'd5:begin
                                reg_32[2] = IO_i;
                            end
                        32'd8:begin
                                data_addr = reg_32[4];
                                simd_load = 1'b1;
                            end
                        32'd9:begin
                                data_addr = reg_32[4];
                                add_r[127:96] = add1[127:96] + add2[127:96];
                                add_r[95:64] = add1[95:64] + add2[95:64];
                                add_r[63:32] = add1[63:32] + add2[63:32];
                                add_r[31:0] = add1[31:0] + add2[31:0];
                                simd_store = 1'b1;
                            end
                        32'd10:begin
                                reg_32[2] = cycle_cnt_i;
                            end
                        32'd11:begin
                                cycle_reset = 1'b1;
                            end
                    endcase
                end
            6'b001101:begin //break
                    exc_code = shamt[3:0];
                end
        endcase
    end
    else if(mode_i == 4'd5 && clk_i)begin // other format
        case (opcode)
            6'b000100:begin //beq
                    b_cond = (reg_32[rs] == reg_32[rt]);
                    b_addr = immediate;
                end
            6'b000101:begin //bne
                    b_cond = (reg_32[rs] != reg_32[rt]);
                    b_addr = immediate;
                end
            6'b100011:begin //lw
                    data_addr = reg_32[rs] + immediate;
                    to_load = rt;
                end
            6'b101011:begin //sw
                    data_addr = reg_32[rs] + immediate;
                    to_store = rt;
                    be_store = 1'b1;
                end
            6'b001000:begin //addi
                    reg_32[rt] = $signed(reg_32[rs]) + $signed({16'd0,immediate});
                end
            6'b001001:begin //addiu
                    reg_32[rt] = reg_32[rs] + {16'd0,immediate};
                end
            6'b001010:begin //slti
                    reg_32[rt][0] = $signed(reg_32[rs]) < $signed({{16{immediate[15]}},immediate});
                end
            6'b001011:begin //sltiu
                    reg_32[rt][0] = (reg_32[rs]) < {16'd0,immediate};
                end
            6'b001100:begin //andi
                    reg_32[rt] = reg_32[rs] & {16'd0,immediate};
                end
            6'b001101:begin //ori
                    reg_32[rt] = reg_32[rs] | {16'd0,immediate};
                end
            6'b001110:begin //xori
                    reg_32[rt] = reg_32[rs] ^ {16'd0,immediate};
                end
            6'b001111:begin //lui
                    reg_32[rt][31:16] = immediate;
                end
            6'b000010:begin //j
                    j_addr = address;
                end
            6'b000011:begin //jal
                    j_addr = address;
                    reg_32[31] = pc_plus4_i;
                end
        endcase
    end
    else if(~clk_i)begin // negedge
        exc_code = 4'd0;
        IO_able = 1'b0;
        cycle_reset = 1'b0;

        if(to_load != 5'd0 && to_load < 5'd28)begin
            reg_32[to_load] = data_load_32_i;
            to_load = 5'd0;
        end

        if(be_store)begin
            data_wen_32 = 1'b1;
            be_store = 1'b0;
        end

        if(simd_load && reg_32[5])begin
            add1 = data_load_128_i;
            simd_load = 1'b0;
        end
        else if(simd_load && ~reg_32[5])begin
            add2 = data_load_128_i;
            simd_load = 1'b0;
        end

        if(simd_store)begin
            data_wen_128 = 1'b1;
            simd_store = 1'b0;
        end
    end
end


endmodule
