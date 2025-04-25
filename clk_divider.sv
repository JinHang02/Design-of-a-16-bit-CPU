// Creating a slow clock from 50 MHz DEO-Nano clock
module clk_divider (
	input wire clk, // 50MHz input clock output wire clk_slow // LED output
	output wire clk_slow	//led output
	) ;
// create a binary counter
	reg [31:0] cnt; // 32-bit counter
	initial begin
		cnt <= 32'h00000000; // start at zero
	end
	always @ (posedge clk) begin 
		cnt <= cnt + 1; // count up
	end
//assign LED to 25th bit of the counter to blink the LED at a few Hz
	assign clk_slow = cnt[22];
endmodule