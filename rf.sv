module RF(
    input [3:0] imem_output_to_rf_input_rs,  // 4-bit rs input
    input [3:0] imem_output_to_rf_input_rt,  // 4-bit rt input
    input [3:0] imem_output_to_rf_input_rd,  // 4-bit destination register
    input [15:0] alu_output_to_rf_input,     // 16-bit data input
    input write_en, rst,                     // 1-bit control signal
    input clk,                               // clock signal
    output [7:0] leds,                      // 8-bit output for LED control at r15
    output [15:0] rf_output_rs_to_alu_input,
    output [15:0] rf_output_rt_to_alu_input // 16-bit output for rs and rt
);

    // Declare 16 registers, each 16 bits wide
    reg [15:0] registers [15:0];

    // Asynchronous read for rs and rt
    assign rf_output_rs_to_alu_input = registers[imem_output_to_rf_input_rs];
    assign rf_output_rt_to_alu_input = registers[imem_output_to_rf_input_rt];

    // LEDs connected to the least significant 8 bits of register 15 (r15)
    assign leds = registers[15][7:0]; // Use r15[7:0] for controlling LEDs

    // Synchronous write operation
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            // Reset all registers to 0 when reset is low, except r0
            registers[0] <= 16'b0; // r0 is always zero
            registers[1] <= 16'b0;
            registers[2] <= 16'b0;
            registers[3] <= 16'b0;
            registers[4] <= 16'b0;
            registers[5] <= 16'b0;
            registers[6] <= 16'b0;
            registers[7] <= 16'b0;
            registers[8] <= 16'b0;
            registers[9] <= 16'b0;
            registers[10] <= 16'b0;
            registers[11] <= 16'b0;
            registers[12] <= 16'b0;
            registers[13] <= 16'b0;
            registers[14] <= 16'b0;
            registers[15] <= 16'b0;
        end else if (write_en) begin
            // Write data to registers, except for r0 (which is read-only and always 0)
            if (imem_output_to_rf_input_rd != 4'b0000) begin
                registers[imem_output_to_rf_input_rd] <= alu_output_to_rf_input; // Write data to register rd
            end
            // r0 will always stay 0, no need to write to it
        end
    end

endmodule
