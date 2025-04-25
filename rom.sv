module IMEM (
  input [15:0] pc_output_to_imem_input,         // 16-bit address input
  input OE,                                     // Output Enable
  output reg [15:0] imem_output_to_rf_input    // 16-bit data output
);

    // Memory array: 512 words, each word is 16 bits (2 bytes)
    reg [15:0] rom [0:511];  // 512 words, each 16 bits

      // initialize the rom to a known assembler program
  initial 
    begin
      rom[0]  = 16'b1111_0000_0101_0001;  // addi r0, r5 , 0001  //r5=1, for decrementing r1
      rom[1]  = 16'b1000_0000_1110_xxxx;  // not r14, r0 , xxxx  //r14=0xffff, for LED display 
      rom[2]  = 16'b1111_0000_0010_0111;  // addi r0, r2 , 0111  //r2=111, for LED display 
      rom[3]  = 16'b1111_0000_0001_0111;  // addi r0, r1 , 0111  //r1=7, count=7
      rom[4]  = 16'b0011_1110_0010_1111;  // and r14, r2 , r15   //r15=r2 write to LED port using AND
      rom[5]  = 16'b0000_0000_0000_0000;  // sw 	// 
      rom[6]  = 16'b1001_0000_0001_0100;  // beq r0, r1 , 4      //if (r1==0), goto 2      
      rom[7]  = 16'b0001_0001_0101_0001;  // sub r1, r5, r1      //r1--
      rom[8]  = 16'b0100_0010_0010_0001;  // shl r2, r2, 1       //r2<<1
      rom[9]  = 16'b1110_0000_0000_0100;  // jmp 4    			  //goto 2
      rom[10] = 16'b0000_0000_0000_0000;  // unused
      rom[11] = 16'b1111_0000_0011_0110;  // addi r0, r3, 0110   //r3=6, count = 7
      rom[12] = 16'b0010_0000_0010_1111;  // or r0, r2, r15      // write to LED port using OR
      rom[13] = 16'b1011_0001_0011_0011;  // bgt r1, r3, 3
      rom[14] = 16'b0000_0001_0101_0001;  // add r1, r5, r1      // r1++
      rom[15] = 16'b0101_0010_0010_0001;  // shr r2, r2, 1       //r2>>1
      rom[16] = 16'b1110_0000_0000_1100;  // jmp 12
      rom[17] = 16'b1110_0000_0000_0011;  // jmp 3
      rom[18] = 16'b0000_0000_0000_0000;  // unused
  end

    // Always block to access memory
    always @ (pc_output_to_imem_input or OE) begin
        if (OE == 1) begin
            // Read 16-bit word from the given address (no need for byte combining)
            imem_output_to_rf_input = rom[pc_output_to_imem_input];
        end else begin
            // High impedance state when OE is 0
            imem_output_to_rf_input = 16'bz;
        end
    end

endmodule
