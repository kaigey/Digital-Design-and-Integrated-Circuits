//(a) Create an 8-bit timer (counting up starting from 0) using a reset register that gives a terminal/
//complete signal (tc) when the maximum value is reached.
//(b) Create a 32-bit timer using only 8-bit timers. (hint: use part (a))
//(c) Create a 24-hour "clock" (with hours, minutes, seconds). Assume a 1 MHz clock frequency.(hint: use part (b))

//PART A
module eightbit_timer(tc, value, reset, clk, enable);
	parameter N = 8;
	input reset, clk, enable;
	output logic tc;
	output [N-1:0] value;
	wire [N-1:0] next;
	
	REGISTER_R #(N) state (.q(value), 
	.d(next), 
	.rst(reset), 
	.clk(clk), 
	.ce(enable));
	assign next = value + 1;
	assign tc = (value == 8'b11111111) ? 1'b1 : 1'b0;

endmodule

//PART B
module thritytwobit_timer (tc, value, reset, clk, en);
	parameter N = 32;
	input reset, clk, en;
	output logic [3:0] tc;
	output [N-1:0] value;
		
	eightbit_timer #(8) t0(.tc(tc[0]), 
	.value(value[7:0]), 
	.d(next[7:0]), 
	.rst(reset), 
	.clk(clk), 
	.enable(en));
	eightbit_timer #(8) t1(.tc(tc[1]), 
	.value(value[15:8]), 
	.d(next[15:8]), 
	.rst(reset), 
	.clk(clk), 
	.enable(tc[0]));
	eightbit_timer #(8) t2(.tc(tc[2]), 
	.value(value[23:16]), 
	.d(next[32:16]), 
	.rst(reset), 
	.clk(clk), 
	.enable(tc[0] && tc[1]));
	eightbit_timer #(8) t3(.tc(tc[3]), 
	.value(value[31:24]), 
	.d(next[31:24]), 
	.rst(reset), 
	.clk(clk), 
	.enable(tc[0] && tc[1] && tc[2]));	

endmodule

//PART C
module clock_timer(tc, value, reset, clk, enable);
	parameter MAX = 63;
	parameter N = 5;
	input reset, clk, enable;
	output logic tc;
	output [N-1:0] value;
	wire [N-1:0] next;
	
	REGISTER_R #(N) state (.q(value), .d(next), .rst(reset), .clk(clk), .ce(enable);
	assign next = (value == MAX) ? 5'd0 : value + 1;
	assign tc = (value == MAX) ? 1'b1 : 1'b0;

endmodule

module clock (sec, min, hr, tc, reset, clk, en);
	parameter N = 5;
	input reset, clk, en;
	output logic [2:0] tc;
	output [5:0] sec, min, hr;
		
	eightbit_timer #(.MAX(59)) sec_counter(.tc(tc[0]),
	.value(sec),
	.rst(reset), 
	.clk(clk), 
	.enable(en));
	eightbit_timer #(.MAX(59)) min_counter(.tc(tc[1]), 
	.value(min), 
	.rst(reset), 
	.clk(clk), 
	.enable(tc[0]));
	eightbit_timer #(.MAX(23)) hr_counter(.tc(tc[2]), 
	.value(hr), 
	.rst(reset), 
	.clk(clk), 
	.enable(tc[0] && tc[1]));
	
endmodule

//Testbench:
`timescale 1ns/1ns
	module clock_test;
	reg clk, en, rst;
	wire [7:0] sec, min, hr;
	wire [1:0] tc;
//Set the initial state of the clock
	initial clk = 0;
// Instantiate device under test
	timer_clock clock(.sec(sec),
	.min(min),
	.hr(hr),
	.rst(rst),
	.en(en),
	.clk(clk),
	.tc(tc));
//Every 4 timesteps (1ns/step) flip the clock
	always #(4) clk <= ~clk;
	initial begin
// Dump waves
	$dumpfile("dump.vcd");
	$dumpvars(1, clock_test);
	clk = 0;
	en = 1;
	rst = 1;
	#8;
	rst = 0;
	$monitor("hr: %d, min: %d, sec: %d", hr, min, sec);
	#20000;
	$finish();
	end
endmodule
