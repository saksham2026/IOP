module control_tb;
    // from/to instruction_memory
    reg [31:0] instruction;
    
    // from pc
    reg [31:0] address_from_pc;
    wire [31:0] address_to_pc_from_control;

    // from/to data_memory
    reg [31:0] data_from_mem;
    wire [31:0] data_to_mem;
    wire [31:0] address_for_data_mem;
    wire write_enable_data_mem;
    wire read_enable_data_mem;

    // to/from register file
    reg [31:0] data_from_rs1;
    reg [31:0] data_from_rs2;
    wire write_enable_register_file;
    wire read_enable_register_file;
    wire [4:0] read_addr_rs1;
    wire [4:0] read_addr_rs2;
    wire [4:0] write_addr_register_file;
    wire [31:0] write_data_rd;

    // -- expected output from the control module

    // to/from pc
    reg [31:0] expected_address_to_pc_from_control;

    // to/from alu
    reg [31:0] data_from_alu;
    wire [3:0] alu_op;

    // expected signals

    // to/from alu
    reg [3:0] expected_alu_op;

    // from/to data_memory
    reg [31:0] expected_address_for_data_mem;
    reg expected_write_enable_data_mem;
    reg expected_read_enable_data_mem;
    reg [31:0] expected_data_to_mem;

    // to/from register file
    reg expected_write_enable_register_file;
    reg expected_read_enable_register_file;
    reg [4:0] expected_read_addr_rs1;
    reg [4:0] expected_read_addr_rs2;
    reg [4:0] expected_write_addr_register_file;
    reg [31:0] expected_write_data_rd;

    // instantiation
    control c0(
        .instruction(instruction),
        .data_from_rs1(data_from_rs1),
        .data_from_rs2(data_from_rs2),
        .data_from_alu(data_from_alu),
        .address_from_pc(address_from_pc),
        .data_from_mem(data_from_mem),
        .address_to_pc_from_control(address_to_pc_from_control),
        .data_to_mem(data_to_mem),
        .address_for_data_mem(address_for_data_mem),
        .write_enable_data_mem(write_enable_data_mem),
        .read_enable_data_mem(read_enable_data_mem),
        .write_enable_register_file(write_enable_register_file),
        .read_enable_register_file(read_enable_register_file),
        .read_addr_rs1(read_addr_rs1),
        .read_addr_rs2(read_addr_rs2),
        .write_addr_register_file(write_addr_register_file),
        .write_data_rd(write_data_rd),
        .alu_op(alu_op)
    );

    task run_check();
    begin
        if (
            expected_address_to_pc_from_control == address_to_pc_from_control &&
            expected_address_for_data_mem == address_for_data_mem &&
            expected_write_enable_data_mem == write_enable_data_mem &&
            expected_read_enable_data_mem == read_enable_data_mem &&
            expected_write_enable_register_file == write_enable_register_file &&
            expected_read_enable_register_file == read_enable_register_file &&
            expected_read_addr_rs1 == read_addr_rs1 &&
            expected_read_addr_rs2 == read_addr_rs2 &&
            expected_write_addr_register_file == write_addr_register_file &&
            expected_write_data_rd == write_data_rd &&
            expected_alu_op == alu_op &&
            expected_data_to_mem == data_to_mem
        ) begin
            $display("[PASS] %32h", instruction);
        end
        else begin
            $display("[FAIL] %32h", instruction);
            $display("Expected | Actual");
            $display("-----------------");
            $display("address_to_pc_from_control %32h %32h", expected_address_to_pc_from_control, address_to_pc_from_control);
            $display("address_for_data_mem %32h %32h", expected_address_for_data_mem, address_for_data_mem);
            $display("write_enable_data_mem %32h %32h", expected_write_enable_data_mem, write_enable_data_mem);
            $display("read_enable_data_mem %32h %32h", expected_read_enable_data_mem, read_enable_data_mem);
            $display("write_enable_register_file %32h %32h", expected_write_enable_register_file, write_enable_register_file);
            $display("read_enable_register_file %32h %32h", expected_read_enable_register_file, read_enable_register_file);
            $display("read_addr_rs1 %32h %32h", expected_read_addr_rs1, read_addr_rs1);
            $display("read_addr_rs2 %32h %32h", expected_read_addr_rs2, read_addr_rs2);
            $display("write_addr_register_file %32h %32h", expected_write_addr_register_file, write_addr_register_file);
            $display("write_data_rd %32h %32h", expected_write_data_rd, write_data_rd);
            $display("alu_op %4b %4b", expected_alu_op, alu_op);
            $display("data_to_mem %32h %32h", expected_data_to_mem, data_to_mem);
        end
    end
endtask


    initial
        begin
            $dumpvars(0,control_tb);
            $dumpfile("Dumpfiles/control.vcd");
            // inputs
            address_from_pc = 32'b0;
            data_from_mem = -1;
            data_from_rs1 = 32'b0;
            data_from_rs2 = 32'b0;

            // expected output 

            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b0;
            expected_read_addr_rs1 = 5'b0;
            expected_read_addr_rs2 = 5'b0;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'b0;
expected_data_to_mem = 0;
        end

        initial
            begin
            // R type instructions // Count = 10
            // ADD
            instruction = 32'b00000000001000001000000000110011; // add x0, x1, x2
            data_from_rs1 = 32'h1;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h3;
            address_from_pc = 32'b0;
expected_data_to_mem = 0;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 4'b0000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h3;
            #10;
            run_check();
            // SUB
            instruction = 32'b01000000001000001000000000110011; // sub x0, x1, x2
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h1;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0001;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h1;
            #10;
            run_check();

            // AND 
            instruction = 32'b00000000001000001111000000110011; // and x0, x1, x2
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h0;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0010;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h0;
            #10;
            run_check();
            // OR 
            instruction = 32'b00000000001000001110000000110011; // or x0, x1, x2
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h6;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0011;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h6;
            #10;
            run_check();
            // XOR 
            instruction = 32'b00000000001000001100000000110011; // xor x0, x1, x2
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h6;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0100;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h6;
            #10;
            run_check();
            // SLL 
            instruction = 32'b00000000001000001001000000110011; // sll x0, x1
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h8;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0101;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h8;
            #10;
            run_check();
            // SRL
            instruction = 32'b00000000001000001101000000110011; // srl x0, x1
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h2;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0110;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h2;
            #10;
            run_check();
            // SRA 
            instruction = 32'b01000000001000001101000000110011; // sra x0, x1
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h2;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0111;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h2;
            #10;
            run_check();
            // SLT 
            instruction = 32'b00000000001000001010000000110011; // slt x0, x1, x2
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h2;
            data_from_alu = 32'h0;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b1001;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h0;
            #10;
            run_check();
            // SLTU
            instruction = 32'b00000000001000001011000000110011; // sltu x0, x1, x2
            data_from_rs1 = 7;
            data_from_rs2 = 9;
            data_from_alu = 1;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b1000;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h1;
            #10;
            run_check();
























































            // I-type for ALU operations // Count = 6
            // ADDI
            instruction = 32'b00000000001100001000000000010011; // addi x0, x1, 3
            data_from_rs1 = 7;
            data_from_rs2 = 0;
            data_from_alu = 10;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
expected_data_to_mem = 0;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 4'b0000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00011;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'hA;
            #10;
            run_check();

            // ANDI
            instruction = 32'b00000000001100001111000000010011; // andi x0, x1, 3
            data_from_rs1 = 7;
            data_from_rs2 = 0;
            data_from_alu = 3;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0010;
            expected_address_to_pc_from_control = 32'b0;
            expected_data_to_mem = 0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 4'b0010;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00011;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h3;
            #10;
            run_check();

            // ORI
            instruction = 32'b00000000001100001110000000010011; // ori x0, x1, 3
            data_from_rs1 = 7;
            data_from_rs2 = 0;
            data_from_alu = 7;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0010;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 4'b0011;
            expected_data_to_mem = 0;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00011;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h7;
            #10;
            run_check();

            // XORI
            instruction = 32'b00000000001100001100000000010011; // xori x0, x1, 3
            data_from_rs1 = 7;
            data_from_rs2 = 0;
            data_from_alu = 0;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0010;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_alu_op = 4'b0100;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00011;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h0;
            #10;
            run_check();

            // SLTI
            instruction = 32'b00000000001100001010000000010011; // addi x0, x1, 3
            data_from_rs1 = 2;
            data_from_rs2 = 0;
            data_from_alu = 1;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b0010;
            expected_data_to_mem =0;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 4'b1001;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00011;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h1;
            #10;
            run_check();
            // SLTIU
            instruction = 32'b00000000001100001011000000010011; // addi x0, x1, 3
            data_from_rs1 = 2;
            data_from_rs2 = 0;
            data_from_alu = 1;
            address_from_pc = 32'b0;
            data_from_mem = 32'b0;
            expected_alu_op = 4'b1000;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 4'b1000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00011;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'h1;
            #10;
            run_check();


            // AUIPC
            instruction = 32'b00000000000000001111000000010111;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_data_to_mem = 0;
            expected_read_enable_register_file = 1'b0;
            expected_read_addr_rs1 = 5'b1;
            expected_read_addr_rs2 = 5'b0;
            expected_write_addr_register_file = 5'b0;
            expected_write_data_rd = 32'b00000000000000001111000000000000;
            #10;
            run_check();


            // Branch Type BEQ, BGE, BNE, BLT, BGEU, BLTU // Count = 6
            // BEQ // Should branch
            instruction = 32'b00000000001000001000001001100011;
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000100;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BEQ  // SHould not branch 
            instruction = 32'b00000000001000001000001001100011;
            data_from_rs1 = 32'h4;
            data_from_rs2 = 32'h3;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000000;
            expected_address_for_data_mem = 32'b0;
            expected_write_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BGE // Should branch
            instruction = 32'b00000000001000001101001001100011;
            data_from_rs1 = 32'h5;
            data_from_rs2 = 32'h4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000100;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BGE // Should not branch
            instruction = 32'b00000000001000001101001001100011;
            data_from_rs1 = -5;
            data_from_rs2 = -4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000000;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BGEU // Should branch
            instruction = 32'b00000000001000001111001001100011;
            data_from_rs1 = 32'h5;
            data_from_rs2 = 32'h4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000100;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BLT // Should branch
            instruction = 32'b00000000001000001100001001100011;
            data_from_rs1 = -5;
            data_from_rs2 = -4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000100;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BLT // Should not branch
            instruction = 32'b00000000001000001100001001100011;
            data_from_rs1 = -4;
            data_from_rs2 = -4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000000;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BLTU // Should branch
            instruction = 32'b00000000001000001100001001100011;
            data_from_rs1 = 3;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000100;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BLTU // Should not branch
            instruction = 32'b00000000001000001100001001100011;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000000;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BNE // Should branch
            instruction = 32'b00000000001000001001001001100011;
            data_from_rs1 = 7;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000100;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // BNE // Should not branch
            instruction = 32'b00000000001000001001001001100011;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000000000;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b00100;
            expected_write_data_rd = 32'b0;
            #10;
            run_check();

            // JAL // Count = 24
            instruction = 32'b00000000100000000000000001101111;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000001000;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b0;
            expected_read_addr_rs1 = 5'b00000;
            expected_read_addr_rs2 = 5'b01000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 4;
            #10;
            run_check();

            // JALR // Count = 25
            instruction = 32'b00000000100000001000000001100111;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b00000000000000000000000000001100;
            expected_address_for_data_mem = 32'b0;
            expected_data_to_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b01000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 4;
            #10;
            run_check();
            
            // LOAD TYPE // Count = 30
            // LB 
            instruction = 32'b00000000100000001000000000000011;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            data_from_mem = -1;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 12;
            expected_write_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_read_enable_data_mem = 1'b1;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b01000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 32'hffffffff;
            #10;
            run_check();

            // LBU 
            instruction = 32'b00000000100000001100000000000011;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 12;
            expected_write_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_read_enable_data_mem = 1'b1;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b01000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 32'h000000ff;
            #10;
            run_check();

            // LH
            instruction = 32'b00000000100000001001000000000011;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_data_to_mem = 0;
            expected_address_for_data_mem = 12;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b1;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b01000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 32'hFFFFFFFF;
            #10;
            run_check();

            // LHU
            instruction = 32'b00000000100000001101000000000011;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_data_to_mem = 0;
            expected_address_for_data_mem = 12;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b1;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b01000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 32'h0000FFFF;
            #10;
            run_check();

            // LW
            instruction = 32'b00000000100000001010000000000011;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_data_to_mem = 0;
            expected_address_for_data_mem = 12;
            expected_write_enable_data_mem = 1'b0;
            expected_read_enable_data_mem = 1'b1;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b01000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 32'hFFFFFFFF;
            #10;
            run_check();

            // LUI // Count = 31
            instruction = 32'b00000000000000001111000000110111;
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 0;
            expected_write_enable_data_mem = 1'b0;
            expected_data_to_mem = 0;
            expected_read_enable_data_mem = 1'b0;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b1;
            expected_read_enable_register_file = 1'b0;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00000;
            expected_write_addr_register_file = 5'b00000;
            expected_write_data_rd = 32'h0000F000;
            #10;
            run_check();

            // Store Instructions // Count = 34
            // SB
            instruction = 32'b00000000001000001000010000100011; // sb x2, 8(x1)
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 12;
            expected_data_to_mem = 4;
            expected_write_enable_data_mem = 1'b1;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 4;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b01000;
            expected_write_data_rd = 0;
            #10;
            run_check();

            // SH
            instruction = 32'b00000000001000001001010000100011; // sh x2, 8(x1)
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 12;
            expected_data_to_mem = 4;
            expected_write_enable_data_mem = 1'b1;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 4;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b01000;
            expected_write_data_rd = 0;
            #10;
            run_check();

            // SW
            instruction = 32'b00000000001000001010010000100011; // sw x2, 8(x1)
            data_from_rs1 = 4;
            data_from_rs2 = 4;
            expected_address_to_pc_from_control = 32'b0;
            expected_address_for_data_mem = 12;
            expected_data_to_mem = 4;
            expected_write_enable_data_mem = 1'b1;
            expected_read_enable_data_mem = 1'b0;
            expected_data_to_mem = 4;
            expected_alu_op = 5'b00000;
            expected_write_enable_register_file = 1'b0;
            expected_read_enable_register_file = 1'b1;
            expected_read_addr_rs1 = 5'b00001;
            expected_read_addr_rs2 = 5'b00010;
            expected_write_addr_register_file = 5'b01000;
            expected_write_data_rd = 0;
            #10;
            run_check();
            $finish;
            end
endmodule