module registerfile(din, dout, we, raddr, waddr);
	parameter N = 4;
	input [N-1:0] din;
	input we;
	input [1:0] raddr, waddr;
	output [N-1:0] dout;
	
	wire w0, w1, w2, w3;
	decoder d0(
	.x0(w0),
	.x1(w1),
	.x2(w2),
	.x3(w3),
	.a(waddr[0]),
	.b(waddr[1]),	
	);

	logic ce0, ce1, ce2, ce3;
	assign ce0 = we && w0;
	assign ce1 = we && w1;
	assign ce2 = we && w2;
	assign ce3 = we && w3;
	
	wire data0, data1, data2, data3;
	register r0(
	.d(din[0]),
	.q(data0),
	.clk(clk),
	.ce(ce0),
	);
	
	register r1(
	.d(din[1]),
	.q(data1),
	.clk(clk),
	.ce(ce1),
	);
	
	register r2(
	.d(din[2]),
	.q(data2),
	.clk(clk),
	.ce(ce2),
	);
	
	register r3(
	.d(din[3]),
	.q(data3),
	.clk(clk),
	.ce(ce3),
	);
	
	muxfour m0(
	.d0(data0),
	.d1(data1),
	.d2(data2),
	.d3(data3),
	.sel(raddr),
	.out(dout),
	);
endmodule

module decoder(x0, x1, x2, x3, a, b);
	input a, b;
	output x0, x1, x2, x3;

	assign x0 = ~a && ~b;
	assign x1 = ~a && b;
	assign x2 = a && ~b;
	assign x3 = a && b;
endmodule

module muxfour(d0, d1, d2， d3, sel, out);
	parameter N = 4;
	input [N-1:0] d0, d1, d2, d4;
	input [1:0] sel;
	output logic [N-1:0] out;
	
	always_comb
	begin
		case (sel)
			2'b00: out = d0;
			2'b01: out = d1;
			2'b10: out = d2;
			2'b11: out = d3;
			default: out = 4'b0;
		endcase
	end
endmodule


//
`timescale 1ns/1ns
	module regfile_test;
	reg clk, we;
	reg [3:0] data_in;
	reg [1:0] raddr, waddr;
	wire [3:0] data_out;
//Set the initial state of the clock
	initial clk = 0;
// Instantiate device under test
	RegFile regfile(.clk(clk),
	.we(we),
	.data_in(data_in),
	.raddr(raddr),
	.waddr(waddr),
	.data_out(data_out));
//Every 4 timesteps (1ns/step) flip the clock
	always #(1) clk <= ~clk;
	initial begin
// Dump waves
	$dumpfile("dump.vcd");
	$dumpvars(1, regfile_test);
	$monitor("data_out = %h", data_out);
// write in a, b, c, d into 00, 01, 10, 11 respectively
	data_in = 4'ha;
	we = 1;
	waddr = 2'b00;
	#2;
	data_in = 4'hb;
	waddr = 2'b01;
	#2;
	data_in = 4'hc;
	waddr = 2'b10;
	#2;
	data_in = 4'hd;
	waddr = 2'b11;
	#2;
	we = 0;
// read out 00, 01, 10, 11
	raddr = 2'b00;
	#2;
	raddr = 2'b01;
	#2;
	raddr = 2'b10;
	#2;
	raddr = 2'b11;
	#2;
	$finish();
	end
endmodule
