//• The vending machine delivers a package of gum after it has received 15 cents in coins.
//• The machine has a single coin slot that accepts only nickels and dimes, one coin at a time.
//• A sensor indicates to the controller whether a nickel or dime has been inserted in the coin
//slot.
//• The controller’s output causes a single package of gum to be released when it has received at
//least 15 cents, and the controller is reset.
//• The machine does not give change. For example, if two dimes are inserted, it will release the
//gum and reset.

module vendingmachine(clk, rst, in, out);
	parameter N = 2;
	input reset, clk;
	input [N-1:0] in
	output logic out;
	
// Defined state encoding:
localparam	idle = 2'b00; 
localparam	fivecents = 2'b01;
localparam	tencents = 2'b10;
localparam	fifteencents = 2'b11;
localparam	invalid = 2'bx;

	wire [N-1:0] cs;
	logic [N-1:0] ns;
//	state register
//	option 1: always block
//	option 2: instantiate submodule
	always_ff @(posedge clk)
	begin
		if (rst)
			cs <= idle;
		else
			cs <= ns;
	end
	register_r #(.N(2)) state(
	.q(cs),
	.d(ns),
	.clk(clk),
	.rst(rst)
	);
	
	always_comb @(*)
	begin
		case (state)
			idle: begin
				if ( in == 2'b00 ) ns = idle;
				else if ( in == 2'b01 ) ns = fivecents;
				else if ( in == 2'b10 ) ns = tencents;
				else ns = invalid;
			end
			fivecents: begin
				if ( in == 2'b00 ) ns = fivecents;
				else if ( in == 2'b01 ) ns = tencents;
				else if ( in == 2'b10 ) ns = fifteencents;
				else ns = invalid;
			end
			tencents: begin
				if ( in == 2'b00 ) ns = tencents;
				else if ( in == 2'b01 ) ns = fifteencents;
				else if ( in == 2'b10 ) ns = fifteencents;
				else ns = invalid;
			end
			fifteencents: begin
				out = 1'b1;
				if ( rst ) ns = idle;
				else ns = fifteencents;
			end
			default: begin
			//initialization	
				ns = idle;
				out = 1'b0;
			end
		endcase
	end
	
endmodule

module register_r (q, d, clk, rst);
	input [N-1:0] d; 
	input clk, rst;
	output logic [N-1:0] q;
	
	always_ff @(posedge clk)
		if (rst)
			q <= 1'b0;
		else
			q <= d;

endmodule