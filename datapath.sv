//`timescale 1ns / 1ps
module Datapath(
    input clk,
    input reset,
    input pc_load,
    input write_en,
    input RW_,
    input CS,
    input OE,
  	input ctrl_output_to_mux_rf_selected_rd_input,
  	input ctrl_output_to_mux_alu_selected_rt_input,
  	input ctrl_output_to_mux_rf_selected_data_in_input,
  	input [3:0] ctrl_output_to_alu_input_opcode,
  	input ctrl_output_to_mux_branch,
  	input ctrl_output_to_mux_jump,
    output [3:0] imem_output_to_control_input_opcode,
    output Zero,
    output Negative,
    output Overflow,
  	output [7:0] LEDs
);
    
    wire [15:0] pc_output_to_imem_input;
    wire [15:0] imem_output_instruction_register_IR;
    wire [15:0] rf_output_rs_to_alu_input;
    wire [15:0] rf_output_rt_to_alu_input;
    wire [15:0] alu_output_to_rf_input;
    wire [15:0] dmem_output_to_rf_input;
  	wire [15:0] imem_output_to_alu_input;
  	wire [15:0] alu_output_to_dmem_addr;
  	wire [3:0] rf_selected_rd;
  	wire [15:0] alu_selected_rt, rf_selected_data_in;
  	wire [15:0] mux_branch_output_to_mux_jump_input;
  	wire [15:0] mux_jump_output_to_pc_input;
  
  	assign imem_output_to_alu_input = {{12{imem_output_instruction_register_IR[3]}}, imem_output_instruction_register_IR[3:0]};
  	assign imem_output_to_control_input_opcode = imem_output_instruction_register_IR[15:12];
  
  	shortint addition_pc_output_plus_2, addition_pc_output_plus_2_plus_imem_output_to_alu_input; //check if this needs to be shortint or can be wire
  	
  	assign addition_pc_output_plus_2 = pc_output_to_imem_input + 16'b01;
  	assign addition_pc_output_plus_2_plus_imem_output_to_alu_input = addition_pc_output_plus_2 + imem_output_to_alu_input;


    // Instantiate Program Counter (PC)
    pc PC (
        .pc_load(pc_load),
        .alu_output_to_rf_input(mux_jump_output_to_pc_input),
        .reset(reset),
        .clk(clk),
        .pc_output_to_imem_input(pc_output_to_imem_input)
    );

    // Instantiate Instruction Memory (IMEM)
    IMEM ROM (
        .pc_output_to_imem_input(pc_output_to_imem_input),
        .OE(OE),
        .imem_output_to_rf_input(imem_output_instruction_register_IR)
    );

    // Instantiate Register File (RF)
    RF RegisterFile (
        .imem_output_to_rf_input_rs(imem_output_instruction_register_IR[11:8]),  // rs register
        .imem_output_to_rf_input_rt(imem_output_instruction_register_IR[7:4]),   // rt register
      	.imem_output_to_rf_input_rd(rf_selected_rd),   		 // rd register
        .alu_output_to_rf_input(rf_selected_data_in),   // Data to RF from DMEM
        .write_en(write_en),
        .rst(reset),
        .clk(clk),
        .rf_output_rs_to_alu_input(rf_output_rs_to_alu_input),
        .rf_output_rt_to_alu_input(rf_output_rt_to_alu_input),
        .leds(LEDs)
    );

    // Instantiate ALU
    ALU alu (
        .rf_output_rs_to_alu_input(rf_output_rs_to_alu_input),
        .rf_output_rt_to_alu_input(alu_selected_rt),
        .imem_output_to_rf_input_opcode(ctrl_output_to_alu_input_opcode),
        .alu_output_to_rf_input(alu_output_to_rf_input),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow)
    );

    // Instantiate Data Memory (DMEM)
    dmem DataMemory (
        .clk(clk),
        .alu_output_to_dmem_addr(alu_output_to_rf_input),  // Address from ALU
        .rf_output_rt_to_alu_input(rf_output_rt_to_alu_input),  // Data input
        .RW_(RW_),  // Read/Write control
        .CS(CS),  // Chip Select
        .dmem_output_to_rf_input(dmem_output_to_rf_input) // Data out to RF
    );
  
    mux_4bit_2to1 mux_rf_selected_rd (
        .I0(imem_output_instruction_register_IR[7:4]),  	// Option 0: Bits [7:4]
        .I1(imem_output_instruction_register_IR[3:0]),  	// Option 1: Bits [3:0]
        .S(ctrl_output_to_mux_rf_selected_rd_input),  	// Select signal
        .Y(rf_selected_rd)                     			// Output of MUX
    );
  
    mux_16bit_2to1 mux_alu_selected_rt (
        .I0(rf_output_rt_to_alu_input),  				
        .I1(imem_output_to_alu_input),  				
        .S(ctrl_output_to_mux_alu_selected_rt_input),  	
        .Y(alu_selected_rt)                     			
    );
  
    mux_16bit_2to1 mux_rf_selected_data_in (
        .I0(dmem_output_to_rf_input),  				
        .I1(alu_output_to_rf_input),  				
      	.S(ctrl_output_to_mux_rf_selected_data_in_input),  	
        .Y(rf_selected_data_in)                     			
    );
  
  	mux_16bit_2to1 mux_branch (
        .I0(addition_pc_output_plus_2),  				
        .I1(addition_pc_output_plus_2_plus_imem_output_to_alu_input),  				
      	.S(ctrl_output_to_mux_branch),  	
      	.Y(mux_branch_output_to_mux_jump_input)                     			
    );
  
    mux_16bit_2to1 mux_jump (
        .I0(mux_branch_output_to_mux_jump_input),  				
        .I1({{4{imem_output_instruction_register_IR[11]}}, imem_output_instruction_register_IR[11:0]}),
        .S(ctrl_output_to_mux_jump),  	
        .Y(mux_jump_output_to_pc_input)                     			
    );

endmodule
