//`timescale 1ns / 1ps

module pc(pc_load, alu_output_to_rf_input, reset, clk, pc_output_to_imem_input);
  input pc_load, reset, clk;
  input [15:0] alu_output_to_rf_input; //16 bits data_in
  output reg [15:0] pc_output_to_imem_input; //16 bits data_out
  
  always @(posedge clk or negedge reset)
    begin
      if (!reset)
          pc_output_to_imem_input <=16'b0; // Reset the output to zero
      else if (pc_load)
          pc_output_to_imem_input <= alu_output_to_rf_input; //Load data_in to data_out
    end
endmodule
