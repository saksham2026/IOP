module control(
    input wire [31:0] instruction,
    input wire [31:0] pc_in,
    input wire [31:0] data1, // data from register file
    input wire [31:0] data2, // data from register file
    input wire [31:0] data_f_alu, // data from alu
    input wire [31:0] data_m, // data from memory
    output reg [31:0] address,
    output reg [31:0] pc_out,
    output reg [31:0] data_to_m, // data to memory
    output reg chip_select_d, // chip select for data memory
    output reg write_enable,
    output reg write_enable_d,
    output reg read_enable,
    output reg read_enable_d,
    output reg [4:0] write_addr,
    output reg [4:0] read_addr1,
    output reg [4:0] read_addr2,
    output reg [31:0] write_data,
    output reg [3:0] alu_op
);
    reg [31:0] immediate;
    always@(*)
        begin
            case(opcode)
                7'b0010111: immediate <= {instruction[31:12], 12'b0}; // U-Type
                7'b1100011: begin if(funct3 == 3'b111 || funct3 == 3'b110) immediate <= {20'b0,instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; else immediate <= {{20{instruction[31]}},instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; end // B-Type
                7'b1101111: immediate <= {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-Type
                7'b1100111: immediate <= { {20{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // I-Type
                7'b0000011: immediate <= { {20{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // I-Type
                7'b0100011: immediate <= { {20{instruction[31]}}, instruction[31:25], instruction[11:7], 1'b0}; // S-Type
                7'b0110111: immediate <= {instruction[31:12], 12'b0}; // U-Type
                default: immediate <= 32'b0;
            endcase
        end
    wire [6:0] opcode;
    assign opcode = instruction[6:0];
    wire [2:0] funct3;
    assign funct3 = instruction[14:12];
    wire [6:0] funct7;
    assign funct7 = instruction[31:25];
    wire [4:0] rs1;
    assign rs1 = instruction[19:15];
    wire [4:0] rs2;
    assign rs2 = instruction[24:20];
    wire [4:0] rd;
    assign rd = instruction[11:7];

    always@(*)
        begin

        end
     always@(*)
         begin
            alu_op <= 4'b0000;
             case(opcode)
                 7'b0110011: // R-Type
                      begin
                      write_enable <= 1'b1;
                      read_enable <= 1'b1;
                      read_addr1 <= rs1;
                      read_addr2 <= rs2;
                      write_addr <= rd;
                      write_enable_d <= 1'b0;
                      read_enable_d <= 1'b0;
                      chip_select_d <= 1'b0;
                      data_to_m <= 32'b0;
                      write_data <= data_f_alu;
                      address <= 32'b0;
                      pc_out <= 32'b0;
                      case(funct3)
                          3'b000: begin if(funct7 == 7'b0100000) alu_op <= 4'b0001; else alu_op <= 4'b0000; end
                          3'b001: alu_op <= 4'b0101;
                          3'b010: alu_op <= 4'b1001;
                          3'b011: alu_op <= 4'b1000;
                          3'b100: alu_op <= 4'b0100;
                          3'b101: begin if(funct7 == 7'b0100000) alu_op <= 4'b0111; else alu_op <= 4'b0110; end
                          3'b110: alu_op <= 4'b0011;
                          3'b111: alu_op <= 4'b0010;
                          default: alu_op <= 4'b0000;
                      endcase
                      end
                7'b0010011: begin // I-Type
                    write_enable <= 1'b1;
                    read_enable <= 1'b1;
                    read_addr1 <= rs1;
                    read_addr2 <= 5'b00000;
                    write_addr <= rd;
                    write_enable_d <= 1'b0;
                    read_enable_d <= 1'b0;
                    chip_select_d <= 1'b0;
                    data_to_m <= 32'b0;
                    write_data <= data_f_alu;
                    address <= 32'b0;
                    pc_out <= 32'b0;
                    case(funct3)
                        3'b000: alu_op <= 4'b0000; // ADDI
                        3'b100: alu_op <= 4'b0100; // XORI
                        3'b011: alu_op <= 4'b1000; // SLTIU
                        3'b010: alu_op <= 4'b1001; // SLTI
                        3'b110: alu_op <= 4'b0011; // ORI
                        3'b111: alu_op <= 4'b0010; // ANDI
                        default: alu_op <= 4'b0000;
                    endcase    
                end
                7'b0010111: begin // AUIPC
                        write_addr <= rd; // U-Type
                        write_data <= pc_in + immediate;
                        alu_op <= 4'b0000;
                        write_enable <= 1'b1;
                        read_enable <= 1'b1;
                        read_addr1 <= rs1;
                        read_addr2 <= 5'b00000;
                        write_enable_d <= 1'b0;
                        read_enable_d <= 1'b0;
                        chip_select_d <= 1'b0;
                        data_to_m <= 32'b0;
                        address <= 32'b0;
                        pc_out <= 32'b0;
                end
                7'b1100011: begin // B-Type
                    read_enable <= 1'b1;
                    read_addr1 <= rs1;
                    read_addr2 <= rs2;
                    alu_op <= 4'b0000;
                    write_addr <= 32'b0;
                    write_enable <= 1'b0;
                    write_enable_d <= 1'b0;
                    read_enable_d <= 1'b0;
                    chip_select_d <= 1'b0;
                    data_to_m <= 32'b0;
                    write_data <= 32'b0;
                    address <= 32'b0;
                    case(funct3)
                        3'b000: begin if(data1 == data2) pc_out <= pc_in + immediate; else pc_out <= 32'b0;  end // BEQ
                        3'b101: begin if($signed(data1) >= $signed(data2)) pc_out <= pc_in + immediate;else pc_out <= 32'b0; end // BGE
                        3'b111: begin if(data1 >= data2) pc_out <= pc_in + immediate; else pc_out <= 32'b0;end // BGEU
                        3'b100: begin if($signed(data1) < $signed(data2)) pc_out <= pc_in + immediate; else pc_out <= 32'b0;end // BLT
                        3'b110: begin if(data1 < data2) pc_out <= pc_in + immediate; else pc_out <= 32'b0;end // BLTU
                        3'b001: begin if(data1 != data2) pc_out <= pc_in + immediate; else pc_out <= 32'b0;end // BNE
                        default: pc_out <= pc_in;
                    endcase
                end
                7'b1101111: begin // J-Type // JAL
                    write_addr <= rd;
                    write_data <= pc_in + 4;
                    read_addr1 <= 5'b00000;
                    read_addr2 <= 5'b00000;
                    pc_out <= pc_in + immediate;
                    alu_op <= 4'b0000;
                    write_enable <= 1'b1;
                    read_enable <= 1'b0;
                    write_enable_d <= 1'b0;
                    read_enable_d <= 1'b0;
                    chip_select_d <= 1'b0;
                    data_to_m <= 32'b0;
                    address <= 32'b0;
                end
                7'b1100111: begin // I-Type // JALR
                    write_enable <= 1'b1;
                    read_enable <= 1'b1;
                    read_addr1 <= rs1;
                    read_addr2 <= 5'b00000;
                    write_addr <= rd;
                    pc_out<= data1 + immediate;
                    write_data <= pc_in + 4;
                    alu_op <= 4'b0000;
                    write_enable_d <= 1'b0;
                    read_enable_d <= 1'b0;
                    chip_select_d <= 1'b0;
                    data_to_m <= 32'b0;
                    address <= 32'b0;
                end
                7'b0000011: begin
                    write_enable_d <= 1'b1;
                    read_enable <= 1'b1;
                    chip_select_d <= 1'b1;
                    read_addr1 <= rs1;
                    read_addr2 <= 5'b00000;
                    write_addr <= rd;
                    address <= data1 + immediate;
                    alu_op <= 4'b0000;
                    write_enable <= 1'b0;
                    read_enable_d <= 1'b0;
                    data_to_m <= 32'b0;
                    pc_out <= 32'b0;
                    case(funct3)
                    3'b000: begin
                        write_data <= {{24{data_m[7]}},data_m}; // LB
                    end
                    3'b100: begin
                        write_data <= {24'b0,data_m[7:0]}; // LBU
                    end
                    3'b001: begin
                        write_data <= {{16{data_m[15]}},data_m[15:0]}; // LHU
                    end
                    3'b101: begin
                        write_data <= {16'b0,data_m[15:0]}; // LH
                    end
                    3'b010: begin
                        write_data <= data_m; // LW
                    end
                    default:
                        write_data <= 32'b0;
                    endcase
                end
                7'b0100011: begin // S-Type
                    read_enable <= 1'b1;
                    read_enable_d <= 1'b1;
                    chip_select_d <= 1'b1;
                    read_addr1 <= rs1;
                    read_addr2 <= rs2;
                    address <= data1 + immediate;
                    alu_op <= 4'b0000;
                    write_enable <= 1'b0;
                    write_enable_d <= 1'b0;
                    pc_out <= 32'b0;
                    write_addr <= 5'b00000;
                    write_data <= 0;
                    case(funct3)
                        3'b000: begin
                            data_to_m <= {{24{data2[7]}},data2[7:0]}; // SB
                        end
                        3'b001: begin
                            data_to_m <= {{16{data2[15]}},data2[15:0]}; // SH
                        end
                        3'b010: begin
                            data_to_m <= data2; // SW
                        end
                        default: data_to_m <= 32'b0;
                    endcase
                end
                7'b0110111: begin // U-Type // LUI
                    write_enable <= 1'b1;
                    read_enable <= 1'b0;
                    write_enable_d <= 1'b0;
                    read_enable_d <= 1'b0;
                    pc_out <= 32'b0;
                    read_addr1 <= 5'b00000;
                    read_addr2 <= 5'b00000;
                    chip_select_d <= 1'b0;
                    data_to_m <= 32'b0;
                    write_addr <= rd;
                    write_data <= immediate;
                    address <= 32'b0;
                    alu_op <= 4'b0000;
                end
                 default: begin
                     write_enable <= 1'b0;
                     read_enable <= 1'b0;
                     read_addr1 <= 5'b0;
                     read_addr2 <= 5'b0;
                     write_addr <= 5'b0;
                     write_enable_d <= 1'b0;
                     read_enable_d <= 1'b0;
                     chip_select_d <= 1'b0;
                     data_to_m <= 32'b0;
                     write_data <= 32'b0;
                     address <= 32'b0;
                     pc_out <= 32'b0;
                     alu_op <= 4'b0000;
                 end
             endcase
         end
endmodule 