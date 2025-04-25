//`timescale 1ns / 1ps
module dmem (
    input wire clk,                  // Clock input
  	input wire [15:0] alu_output_to_dmem_addr,         // 16-bit address
  	input wire [15:0] rf_output_rt_to_alu_input,      // 16-bit data_in
    input wire RW_,                 // Read/Write control (1 for read, 0 for write)
    input wire CS,                  // Chip select
  	output reg [15:0] dmem_output_to_rf_input      // 16-bit data_out
);

    // Memory array (1KB = 1024 bytes = 512 16-bit words)
    // Implement as byte addressable but with 16-bit ports
  reg [15:0] memory [0:511];      // 1KB byte-addressable memory

    // Tri-state output control
    always @(*) begin
        if (!CS) begin
            // High impedance state when chip select is inactive
            dmem_output_to_rf_input  = 16'bz;
        end
        else if (RW_) begin
            // Read operation
          if (alu_output_to_dmem_addr < 511) begin
                // Little-endian byte ordering (like RISC-V)
                dmem_output_to_rf_input = memory[alu_output_to_dmem_addr];
            end
            else begin
                // Address beyond memory space
                dmem_output_to_rf_input  = 16'b0;
            end
        end
        else begin
            // During write operation, output is high impedance
            dmem_output_to_rf_input  = 16'bz;
        end
    end

    // Write operation (synchronized to clock)
    always @(posedge clk) begin
      	if (CS && !RW_ && alu_output_to_dmem_addr < 511) begin
            // Little-endian byte ordering
            memory[alu_output_to_dmem_addr] = rf_output_rt_to_alu_input;
        end
    end

endmodule