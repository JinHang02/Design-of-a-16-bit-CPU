//`timescale 1ns / 1ps
module mux_4bit_2to1 (
    input [3:0] I0,    // First 4-bit input
    input [3:0] I1,    // Second 4-bit input
    input S,           // Select signal
    output reg [3:0] Y // 4-bit output
);
    always @(*) begin
        if (S == 0)
            Y = I0;    // Select I0 when S=0
        else
            Y = I1;    // Select I1 when S=1
    end
endmodule

module mux_16bit_2to1 (
    input [15:0] I0,    // First 16-bit input
    input [15:0] I1,    // Second 16-bit input
    input S,           // Select signal
    output reg [15:0] Y // 16-bit output
);
    always @(*) begin
        if (S == 0)
            Y = I0;    // Select I0 when S=0
        else
            Y = I1;    // Select I1 when S=1
    end
endmodule

