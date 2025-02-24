module processor(
    input wire clk_in,
    input wire reset,
    input wire resetC,
    output reg verify [7:0]
);
    // related to register file
    wire clk;

    // realted to control
    wire [31:0] address_to_pc_from_control;
    wire addr_sel_for_pc;
    
    wire [31:0] sample;
    wire [31:0] address_for_data_mem;
    wire [31:0] data_to_mem;
    wire [31:0] data_from_mem;
    wire read_enable_data_mem;
    wire write_enable_data_mem;

    wire [31:0] data_from_rs1;
    wire [31:0] data_from_rs2;
    wire [4:0] read_addr1;
    wire [4:0] read_addr2;
    wire [4:0] write_addr;
    wire read_enable_register_file;
    wire write_enable_register_file;
    wire [31:0] write_data;

    // related to pc
    wire [31:0] pc_in;
    wire [31:0] pc_out;

    // related to add4
    wire [31:0] pc_out_add;

    // related to ALU
    wire [31:0] operandB;
    wire [31:0] operandA;
    wire [31:0] result;
    wire [4:0] alu_op;
    wire sel_for_alu;
    wire [31:0] data_for_alu;

    // related to instruction_memory
    wire [31:0] address;
    wire [31:0] instruction;

    add4 add4_0(
        .pc_in(pc_in),
        .pc_out(pc_out_add)
    );

    mux mux0(
        .i0(pc_out_add),
        .i1(address_to_pc_from_control),
        .sel(addr_sel_for_pc),
        .y(pc_in)
    );

    mux mux1(
        .i0(data_from_rs2),
        .i1(data_for_alu),
        .sel(sel_for_alu),
        .y(operandB)
    );
    register_file register_file0(
        .clk(clk),
        .reset(reset),
        .read_enable(read_enable_register_file),
        .write_enable(write_enable_register_file),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .data_out1(data_from_rs1),
        .data_out2(data_from_rs2),
        .sample(sample)
    );
    instruction_memory instruction_memory0(
        .instruction(instruction),
        .address(address)
    );

    program_counter program_counter0(
        .pc_in(pc_in),
        .pc_out(address),
        .clk(clk),
        .reset(reset)
    );

    alu alu0(
        .operandA(operandA),
        .operandB(operandB),
        .alu_op(alu_op),
        .result(result)
    );

    data_memory data_memory(
        .clk(clk),
        .reset(reset),
        .address(address_for_data_mem),
        .write_data(data_to_mem),
        .write_enable(write_enable_data_mem),
        .read_enable(read_enable_data_mem),
        .read_data(data_from_mem)
    );

    control control(
        .instruction(instruction),
        .address_from_pc(address),
        .address_to_pc_from_control(address_to_pc_from_control),
        .addr_sel_for_pc(addr_sel_for_pc),

        .write_enable_data_mem(write_enable_data_mem),
        .read_enable_data_mem(read_enable_data_mem),
        .data_to_mem(data_to_mem),
        .data_from_mem(data_from_mem),
        .address_for_data_mem(address_for_data_mem),

        .data_from_rs1(data_from_rs1),
        .data_from_rs2(data_from_rs2),
        .write_enable_register_file(write_enable_register_file),
        .read_enable_register_file(read_enable_register_file),
        .write_addr_register_file(write_addr),
        .read_addr_rs1(read_addr1),
        .read_addr_rs2(read_addr2),
        .write_data_rd(write_data),

        .alu_op(alu_op),
        .data_for_alu(data_for_alu),
        .sel_for_alu(sel_for_alu),
        .data_from_alu(result)
    );

    clock_divider clocl_divider0(
        .clk_in(clk_in),
        .reset(resetC),
        .clk(clk)
    );
endmodule