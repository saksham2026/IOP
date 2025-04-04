module control(
    // Signals from/to instruction_memory
    input wire [31:0] instruction, // instruction from insruction memory

    // Signals from/to program_counter
    input wire [31:0] address_from_pc, // input for program counter
    output reg [31:0] address_to_pc_from_control, // output from program counter
    output reg addr_sel_for_pc, // Whether pc is simply incremented or obtained from the decode immediate

    // Signals from/to data_memory
    output reg write_enable_data_mem, // write enable for data memory
    output reg read_enable_data_mem, // read enable for data memory
    output reg [31:0] data_to_mem, // data to memory
    input wire [31:0] data_from_mem, // data from memory
    output reg [31:0] address_for_data_mem, // address for accessing memory

    // Signals from/to register_file
    input wire [31:0] data_from_rs1, // data from register file
    input wire [31:0] data_from_rs2, // data from register file
    output reg write_enable_register_file, // write_enable for register file
    output reg read_enable_register_file, // read enable for register file
    output reg [4:0] write_addr_register_file, // address of rd
    output reg [4:0] read_addr_rs1, // address of rs1
    output reg [4:0] read_addr_rs2, // address of rs2
    output reg [31:0] write_data_rd, // data to rd

    // Signals from/to alu
    output reg [3:0] alu_op,
    output reg [31:0] data_for_alu, // immediate data to alu
    output reg sel_for_alu, // select signal for alu operandB
    input wire [31:0] data_from_alu // data from alu
);
    reg [31:0] immediate;
    always@(*)
        begin
            case(opcode)
                7'b0010011: immediate <= {{20{instruction[31]}},instruction[31:20]}; // ADDI, ANDI, ORI, XORI, SLTI, SLTIU 
                // Count = 6

                7'b0010111: immediate <= {instruction[31:12],12'b0}; // AUIPC 
                // Count = 1

                7'b1100011: immediate <= {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0}; // BEQ, BGE, BGEU, BNE, BLT, BLTU
                // Count = 6

                7'b1101111: immediate <= {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // JAL
                // Count = 1

                7'b1100111: immediate <= { {20{instruction[31]}},instruction[31:20]}; // JALR
                // Count = 1

                7'b0000011: immediate <= { {20{instruction[31]}},instruction[31:20]}; // LB, LBU, LH, LHU, LW
                // Count = 5

                7'b0100011: immediate <= { {20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // SB, SH, SW
                // Count = 3

                7'b0110111: immediate <= {instruction[31:12], 12'b0}; // LUI
                // Count = 1
                default: immediate <= 32'b0;
            endcase
    end
    wire [6:0] opcode; // 7 bit opcode decoded from 32 bit instruction
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
                      data_for_alu <= 32'b0;
                      read_addr_rs2 <= rs2;
                      read_addr_rs1 <= rs1;
                      write_addr_register_file <= rd;
                      write_enable_register_file <= 1'b0;
                      read_enable_register_file <= 1'b0;
                      write_data_rd <= 1'b0;
                      sel_for_alu <= 1'b0; // alu operandB from immediate
                      alu_op <= 5'b0; // Not required
                      address_to_pc_from_control <= 32'b0;
                      addr_sel_for_pc <= 1'b0;
                      write_enable_data_mem <= 1'b0;
                      read_enable_data_mem <= 1'b0;
                      address_for_data_mem <= 32'b0;
                      data_to_mem = 32'b0;
             case(opcode)
                 7'b0110011: // R-Type // count = 10;
                      begin
                      // signals for register_file
                      write_enable_register_file <= 1'b1;
                      read_enable_register_file <= 1'b1;
                      write_data_rd <= data_from_alu;

                      case(funct3)
                          3'b000: begin if(funct7 == 7'b0100000) alu_op <= 4'b0001; else alu_op <= 4'b0000; end // ADD, SUB
                          3'b001: alu_op <= 4'b0101; // SLL
                          3'b010: alu_op <= 4'b1001; // SLT
                          3'b011: alu_op <= 4'b1000; // SLTU
                          3'b100: alu_op <= 4'b0100; // XOR
                          3'b101: begin if(funct7 == 7'b0100000) alu_op <= 4'b0111; else alu_op <= 4'b0110; end // SRA, SRL
                          3'b110: alu_op <= 4'b0011; // OR
                          3'b111: alu_op <= 4'b0010; // AND
                          default: alu_op <= 4'b0000;
                      endcase
                      end
                7'b0010011: begin // I-Type // Count = 16
                      write_enable_register_file <= 1'b1;
                      read_enable_register_file <= 1'b1;
                      write_data_rd <= data_from_alu;
                      addr_sel_for_pc <= 1'b0;
                      data_for_alu <= immediate;
                      // signals for alu
                      sel_for_alu <= 1'b1; // alu operandB from immediate

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
                7'b0010111: begin // AUIPC // Count = 17
                      write_enable_register_file <= 1'b1;
                      read_enable_register_file <= 1'b0;
                      write_data_rd <= immediate + address_from_pc;
                end
                7'b1100011: begin // B-Type // Count = 23
                      // Control signals for register file
                      read_enable_register_file <= 1'b1;

                    case(funct3)
                        3'b000: begin 
                        if(data_from_rs1 == data_from_rs2) begin 
                        address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                        addr_sel_for_pc <= 1'b1; 
                        end 
                        else begin 
                        address_to_pc_from_control <= 32'b0; 
                        addr_sel_for_pc <= 1'b0; 
                        end 
                        end // BEQ
                        

                        3'b101: begin 
                        if($signed(data_from_rs1) >= $signed(data_from_rs2)) begin 
                        address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                        addr_sel_for_pc <= 1'b1; 
                        end 
                        else begin 
                        address_to_pc_from_control <= 32'b0; 
                        addr_sel_for_pc <= 1'b0; 
                        end 
                        end // BGE

                        3'b111: begin 
                        if(data_from_rs1 >= data_from_rs2) begin 
                        address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                        addr_sel_for_pc <= 1'b1; 
                        end 
                        else begin 
                        address_to_pc_from_control <= 32'b0; 
                        addr_sel_for_pc <= 1'b0; 
                        end 
                        end // BGEU

                        3'b100: begin if($signed(data_from_rs1) < $signed(data_from_rs2)) begin 
                        address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                        addr_sel_for_pc <= 1'b1; 
                        end 
                        else begin 
                        address_to_pc_from_control <= 32'b0; 
                        addr_sel_for_pc <= 1'b0; 
                        end 
                        end // BLT

                        3'b110: begin if(data_from_rs1 < data_from_rs2) begin 
                        address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                        addr_sel_for_pc <= 1'b1; 
                        end 
                        else begin 
                        address_to_pc_from_control <= 32'b0; 
                        addr_sel_for_pc <= 1'b0; 
                        end 
                        end // BLTU

                        3'b001: begin if(data_from_rs1 != data_from_rs2) begin 
                        address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                        addr_sel_for_pc <= 1'b1; 
                        end 
                        else begin 
                        address_to_pc_from_control <= 32'b0; 
                        addr_sel_for_pc <= 1'b0; 
                        end 
                        end // BNE
                        default: address_to_pc_from_control <= address_from_pc;
                    endcase
                end
                7'b1101111: begin // JAL // Count = 24
                      // Control signals for register file
                      write_enable_register_file <= 1'b1;
                      write_data_rd <= address_from_pc + 4;

                      // Signals for program counter
                      address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                      addr_sel_for_pc <= 1'b1;

                end
                7'b1100111: begin // I-Type // JALR Count = 25
                      // Control signals for register file
                      write_enable_register_file <= 1'b1;
                      read_enable_register_file <= 1'b1;
                      write_data_rd <= address_from_pc + 4;

                      // Signals for program counter
                     address_to_pc_from_control <= $signed(address_from_pc) + $signed(immediate);
                      addr_sel_for_pc <= 1'b1;

                end
                7'b0000011: begin // LOAD
                      write_enable_register_file <= 1'b1;
                      read_enable_register_file <= 1'b1;

                      // Signals for data memory
                      read_enable_data_mem <= 1'b1;
                      address_for_data_mem <= data_from_rs1 + immediate;
                    case(funct3)
                    3'b000: begin
                    write_data_rd <= {{24{data_from_mem[7]}},data_from_mem[7:0]};
                    end // LB

                    3'b100: begin
                        write_data_rd <= {24'b0,data_from_mem[7:0]}; // LBU
                    end // LBU

                    3'b001: begin
                        write_data_rd <= {{16{data_from_mem[15]}},
                        data_from_mem[15:0]}; // LH
                    end
                    3'b101: begin
                        write_data_rd <= {16'b0,data_from_mem[15:0]}; // LHU
                    end
                    3'b010: begin
                        write_data_rd <= data_from_mem; // LW
                    end
                    default:
                        write_data_rd <= 32'b0;
                    endcase
                end
                7'b0100011: begin // S-Type
                      // Control Signals for register file
                      read_enable_register_file <= 1'b1;

                      // Signals for data memory
                      write_enable_data_mem <= 1'b1;
                      address_for_data_mem <= data_from_rs1 + immediate;

                    case(funct3)
                        3'b000: begin
                            data_to_mem <= {{24{data_from_rs2[7]}}
                            ,data_from_rs2[7:0]}; // SB
                        end
                        3'b001: begin
                            data_to_mem <= {{16{data_from_rs2[15]}},
                            data_from_rs2[15:0]}; // SH
                        end
                        3'b010: begin
                            data_to_mem <= data_from_rs2; // SW
                        end
                        default: data_to_mem <= 32'b0;
                    endcase
                end
                7'b0110111: begin // LUI
                      // Control Signals for register file
                      write_enable_register_file <= 1'b1;
                      write_data_rd <= immediate;
                end
                 default: begin
                      write_enable_register_file <= 1'b0;
                      read_enable_register_file <= 1'b0;
                      write_data_rd <= immediate + address_from_pc;

                      // signals for alu
                      sel_for_alu <= 1'b0; // alu operandB from immediate
                      alu_op <= 5'b0; // Not required

                      // signals for instruction memory
                      // ---- No control signals for instruction memory

                      // Signals for program counter
                      address_to_pc_from_control <= 32'b0;
                      addr_sel_for_pc <= 1'b0;

                      // Signals for data memory
                      write_enable_data_mem <= 1'b0;
                      read_enable_data_mem <= 1'b0;
                      address_for_data_mem <= 32'b0;
                      data_to_mem = 32'b0;
                 end
             endcase
        end
endmodule 
