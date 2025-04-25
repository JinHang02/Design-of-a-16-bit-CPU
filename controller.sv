//`timescale 1ns / 1ps
module controller (
  	input clk,
  	input rst,
    input wire [3:0] opcode,   // 4-bit opcode from instruction
  	input Zero,
  	input Negative,
  	input Overflow,
  	output reg 		 pc_load,
  	output reg 		 i_mem_oe,
  	output reg 		 rf_mux_sel, //mux before going into rf
  	output reg 		 rf_write_en, //write_en for rf
  	output reg		 alu_mux_sel, //mux before going into alu
  	output reg [3:0] alu_opcode,    // ALU operation selection
    output reg       d_mem_rw_,  //rw_ for dmem
    output reg       d_mem_cs, 	//cs for dmem
    output reg 		 data_out_mux, //data_out from dmem into mux
    output reg       branch,    // Branch signal
    output reg       jump       // Jump signal
);

always @(*) begin
    // Default values
  if (!rst) begin
    pc_load = 1'b0;
    i_mem_oe = 1'b0;
    rf_mux_sel = 1'b1;
    rf_write_en = 1'b0;
	alu_mux_sel = 1'b0;
    alu_opcode = 4'b0000;
    d_mem_rw_ = 1'b0;
    d_mem_cs = 1'b0;
    data_out_mux = 1'b1;
    branch = 1'b0;
    jump = 1'b0;
  end
  
  else begin
    pc_load = 1'b0;
    i_mem_oe = 1'b1;
    rf_mux_sel = 1'b1;
    rf_write_en = 1'b0;
	alu_mux_sel = 1'b0;
    alu_opcode = 4'b0000;
    d_mem_rw_ = 1'b0;
    d_mem_cs = 1'b0;
    data_out_mux = 1'b1;
    branch = 1'b0;
    jump = 1'b0;
    
    case (opcode)
        // R-type instructions (add, sub, or, and)
        4'b0000: begin //Add
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b1;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b0;
            alu_opcode = 4'b0000;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      
      	4'b0001: begin //Sub
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b1;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b0;
            alu_opcode = 4'b0001;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      	
      	4'b0010: begin //Or
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b1;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b0;
            alu_opcode = 4'b0010;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      
      	4'b0011: begin //And
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b1;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b0;
            alu_opcode = 4'b0011;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end

        // S-type (shift, rotate, NOT, addi)
        4'b0100: begin //shift left
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b0100;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      	
      	4'b0101: begin //shift right
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b0101;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      	
      	4'b0110: begin //rotate left
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b0110;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
		
      	4'b0111: begin //rotate right
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b0111;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      	
      	4'b1000: begin //not
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b1000;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      	
      	4'b1111: begin //addi
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b1111; //should be 1111 **
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end
      	
        // B-type (Branch instructions)
        4'b1001: begin //Beq
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b0;
            alu_mux_sel = 1'b0;
            alu_opcode = 4'b0001;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b0;
//             branch = 1'b0;
            jump = 1'b0;
          if (Zero) branch = 1'b1;
        end
      
        4'b1010: begin //Blt
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b0;
            alu_mux_sel = 1'b0;
            alu_opcode = 4'b0001;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b0;
//             branch = 1'b0;
            jump = 1'b0;
          if (Negative) branch = 1'b1;
        end
      
		4'b1011: begin //Bgt
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b0;
            alu_mux_sel = 1'b0;
            alu_opcode = 4'b0001;
            d_mem_rw_ = 1'b0;
            d_mem_cs = 1'b0;
            data_out_mux = 1'b0;
//             branch = 1'b0;
            jump = 1'b0;
          if (!Zero && !Negative) branch = 1'b1;
        end
      
      
        // L-type (Load and Store)
        4'b1100: begin //Ld
          	pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'b0;
            rf_write_en = 1'b1;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b0000;
            d_mem_rw_ = 1'b1; //read
            d_mem_cs = 1'b1;
            data_out_mux = 1'b0;
          	branch = 1'b0;
            jump = 1'b0;
        end
      
        4'b1101: begin //St
          	pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'bx; //dont care
            rf_write_en = 1'b0;
            alu_mux_sel = 1'b1;
            alu_opcode = 4'b0000;
            d_mem_rw_ = 1'b0; //write
            d_mem_cs = 1'b1;
            data_out_mux = 1'bx; //dont care
          	branch = 1'b0;
            jump = 1'b0;
        end

        // J-type (Jump)
        4'b1110: begin
            pc_load = 1'b1;
            i_mem_oe = 1'b1;
            rf_mux_sel = 1'bx; //dont care
            rf_write_en = 1'b0;
            alu_mux_sel = 1'b0; //** should be dont care
            alu_opcode = 4'b0000;
            d_mem_rw_ = 1'b0; 
            d_mem_cs = 1'b0;
            data_out_mux = 1'bx; //dont care
          	branch = 1'b0;
            jump = 1'b1;
        end

//         default: begin
//             // Invalid opcode: Do nothing (NOP)
//         end
    endcase
  end
end

endmodule
