`timescale 1ns / 1ps
/*`include "controller.sv"
`include "datapath.sv"
`include "alu.sv"
`include "dmem.sv"
`include "mux.sv"
`include "pc.sv"
`include "rom.sv"
`include "rf.sv" */

module design (
    input logic clk,           // Clock input
    input logic reset,         // Reset input
    output logic [7:0] LEDs    // LEDs output from RF module (for debugging or status)
);

    // Internal signals for connecting controller and datapath
    logic [3:0] opcode;  // Opcode fetched from IMEM
    logic Zero, Negative, Overflow;

    // Control signals from controller
    logic pc_load;
    logic i_mem_oe;
    logic rf_mux_sel;
    logic rf_write_en;
    logic alu_mux_sel;
    logic [3:0] alu_opcode;
    logic d_mem_rw_;
    logic d_mem_cs;
    logic data_out_mux;
    logic branch;
    logic jump;

    // Additional control signals for datapath
    logic ctrl_output_to_mux_rf_selected_rd_input;
    logic ctrl_output_to_mux_alu_selected_rt_input;
    logic ctrl_output_to_mux_rf_selected_data_in_input;
    logic [3:0] ctrl_output_to_alu_input_opcode;
    logic ctrl_output_to_mux_branch;
    logic ctrl_output_to_mux_jump;

    // Instantiate the datapath module
    Datapath dp_inst (
        .clk(clk),
        .reset(reset),
        .pc_load(pc_load),                      // Connected to controller
        .write_en(rf_write_en),                 // Connected to controller
        .RW_(d_mem_rw_),                        // Connected to controller
        .CS(d_mem_cs),                          // Connected to controller
        .OE(i_mem_oe),                          // Connected to controller
        .ctrl_output_to_mux_rf_selected_rd_input(rf_mux_sel), // Connected to controller
        .ctrl_output_to_mux_alu_selected_rt_input(alu_mux_sel), // Connected to controller
        .ctrl_output_to_mux_rf_selected_data_in_input(data_out_mux), // Connected to controller
        .ctrl_output_to_alu_input_opcode(alu_opcode), // Connected to controller
        .ctrl_output_to_mux_branch(branch),  // Connected to controller
        .ctrl_output_to_mux_jump(jump),      // Connected to controller
        .imem_output_to_control_input_opcode(opcode),  // Opcode output to controller
        .Zero(Zero),                         // Zero flag to controller
        .Negative(Negative),                       // Negative flag to controller
        .Overflow(Overflow),                       // Overflow flag to controller
        .LEDs(LEDs)                           // Debugging output
    );

    // Instantiate the controller module
    controller ctrl_inst (
        .clk(clk),
        .rst(reset),
        .opcode(opcode),   // Opcode comes from IMEM in Datapath
        .Zero(Zero),                         // Zero flag to controller
        .Negative(Negative),                       // Negative flag to controller
        .Overflow(Overflow),
        .pc_load(pc_load),
        .i_mem_oe(i_mem_oe),
        .rf_mux_sel(rf_mux_sel),
        .rf_write_en(rf_write_en),
        .alu_mux_sel(alu_mux_sel),
        .alu_opcode(alu_opcode),
        .d_mem_rw_(d_mem_rw_),
        .d_mem_cs(d_mem_cs),
        .data_out_mux(data_out_mux),
        .branch(branch),
        .jump(jump)
    );

endmodule
