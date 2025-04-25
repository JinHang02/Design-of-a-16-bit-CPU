//`timescale 1ns / 1ps

module ALU(
    input [15:0] rf_output_rs_to_alu_input, // ALU gets rs from RF
    input [15:0] rf_output_rt_to_alu_input, // ALU gets rt from RF
    input [3:0] imem_output_to_rf_input_opcode, // Opcode from IMEM (instruction)
    output reg [15:0] alu_output_to_rf_input, // ALU result goes to RF
    output reg Zero, Negative, Overflow
);
    reg signed [15:0] signed_rs, signed_rt, signed_Result;

    always @(*) begin
        // Default values
        Zero = 0;
        Negative = 0;
        Overflow = 0;
        signed_rs <= rf_output_rs_to_alu_input;
        signed_rt <= rf_output_rt_to_alu_input;

        case (imem_output_to_rf_input_opcode)
            4'b0000: begin // ADD
                signed_Result = signed_rs + signed_rt;
                Overflow = ((signed_rs[15] == signed_rt[15]) && (signed_Result[15] != signed_rs[15]));
                alu_output_to_rf_input = signed_Result;
            end
            4'b0001: begin // SUB
                signed_Result = signed_rs - signed_rt;
                Overflow = ((signed_rs[15] != signed_rt[15]) && (signed_Result[15] != signed_rs[15]));
                alu_output_to_rf_input = signed_Result;
            end
            4'b0010: alu_output_to_rf_input = signed_rs | signed_rt; // OR
            4'b0011: alu_output_to_rf_input = signed_rs & signed_rt; // AND
            4'b0100: alu_output_to_rf_input = signed_rs <<< rf_output_rt_to_alu_input[3:0]; // SHL (Arithmetic Shift Left)
            4'b0101: alu_output_to_rf_input = $signed(rf_output_rs_to_alu_input) >>> rf_output_rt_to_alu_input[3:0]; // SHR (Arithmetic Shift Right)
            4'b0110: alu_output_to_rf_input = {rf_output_rs_to_alu_input[14:0], rf_output_rs_to_alu_input[15]}; // ROL (Rotate Left)
            4'b0111: alu_output_to_rf_input = {rf_output_rs_to_alu_input[0], rf_output_rs_to_alu_input[15:1]}; // ROR
            4'b1000: alu_output_to_rf_input = ~rf_output_rs_to_alu_input; // NOT
            4'b1111: alu_output_to_rf_input = signed_rs + {{12{rf_output_rt_to_alu_input[3]}}, rf_output_rt_to_alu_input[3:0]}; // ADDI (Sign-extended)
            default: alu_output_to_rf_input = 16'b0;
        endcase

        // Zero flag
        Zero = (alu_output_to_rf_input == 16'b0) ? 1'b1 : 1'b0;
        
        // Negative flag
        Negative = alu_output_to_rf_input[15];
    end
endmodule
