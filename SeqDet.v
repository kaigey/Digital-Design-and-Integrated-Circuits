//Design a finite state machine that asserts a single output whenever its input string has at least two
//1’s in a row. The input takes in 1 bit at a time. For example, an input sequence of 0110111 would
//yield an output sequence of 0010011. Since the 2nd and 3rd bits are both 1’s, the 3rd output
//would be 1. Since the 4th, 5th, and 6th bits are 1’s, the 5th and 6th output would be 1’s

//MOORE FSM
module moorefsm(in, out, clk, rst);
	parameter N = 2;
	input in, clk, rst;
	output logic out;
	
// Defined state encoding:
localparam	s0 = 2'b00;
localparam	s1 = 2'b01;
localparam	s2 = 2'b11;

	wire [N-1:0] cs;
	logic [N-1:0] ns;
//	state register instantiate register submodule
	register_r #(.N(2)) state(
	.q(cs),
	.d(ns),
	.clk(clk),
	.rst(rst)
	);
	
	always_comb @(*)
	begin
		case (state)
			s0: begin
				if ( in == 1'b1 ) 
					ns = s1;			
				else 
					ns = s0;			
			end
			s1: begin
				if ( in == 1'b1 ) 
					ns = s2;			
				else 
					ns = s0;
			end
			s2: begin
				out = 1'b1;
				if ( in == 1'b1 ) 
					ns = s2;
				else 
					ns = s0;							
			end									
			default: begin
			//initialization	
				ns = s0;
				out = 1'b0;
			end
		endcase
	end
	
	assign out = ( ps == s2)? 1'b1: 1'b0;
	
endmodule

//MEALY FSM
module mealyfsm(in, out, clk, rst);
	parameter N = 1;
	input in, clk, rst;
	output logic out;
	
// Defined state encoding:
localparam	s0 = 1'b0;
localparam	s1 = 1'b1;

	wire [N-1:0] cs;
	logic [N-1:0] ns;
//	state register instantiate register submodule
	register_r #(.N(2)) state(
	.q(cs),
	.d(ns),
	.clk(clk),
	.rst(rst)
	);
	
	always_comb @(*)
	begin
		case (state)
			s0: begin
				if ( in == 1'b1 ) 
					out = 1'b0;
					ns = s1;			
				else 
					out = 1'b0;					
					ns = s0;			
			end
			s1: begin
				if ( in == 1'b1 ) 
					out = 1'b1;
					ns = s1;	
				else 
					out = 1'b0;
					ns = s0;
			end					
			default: begin
			//initialization	
				ns = s0;
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