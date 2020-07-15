// • The lights in the Uni Ave direction should be green as long as there are no cars on MLK Way.
//• When a car is detected on MLK Way, the Uni Ave lights should go from yellow to red. MLK
//Way will be green when Uni Ave is red.
//• MLK Way will stay green as long as there are cars detected or until a set interval has passed,
//since Uni Ave is busier and needs to return to green. If these conditions are met, MLK Way
//will go from green to yellow to red. Uni Ave will be green when MLK Way is red.
//• Even if there are cars detected on MLK Way, Uni Ave will should stay green for a set interval.
//• There is an external timer outside the controller that takes in a control signal ST (set timer)
//that asserts a signal TS after a short interval (for yellow to red timing) and a signal TL after
//a longer time interval (for green lights). The timer is reset when ST is asserted.


module trafficlight(ug, uy, ur, mg, my, mr, c, st, tl, ts, rst, clk);
	parameter N = 4;
	input rst, clk, c, tl, ts;
	output logic ug, uy, ur, mg, my, mr, st;
	
// Defined one hot state encoding:
localparam	s0 = 4'b0001; //uni_green, mlk_red
localparam	s1 = 4'b0010; //uni_yellow, mlk_red
localparam	s2 = 4'b0100; //mlk_green, uni_red
localparam	s3 = 4'b1000; //mlk_yellow, uni_red

	wire [N-1:0] cs;
	logic [N-1:0] ns;
//	state register
//	option 1: always block

	always_ff @(posedge clk)
	begin
		if (rst)
			cs <= idle;
		else
			cs <= ns;
	end
//	option 2: instantiate submodule
	register_r #(.N(4)) state(
	.q(cs),
	.d(ns),
	.clk(clk),
	.rst(rst)
	);
	
	always_comb @(*)
	begin
		case (state)
			s0: begin
				if ( tl && c ) 
					ns = s1;
					st = 1;
					{ug, uy, ur, mg, my, mr} = 6'b010001;				
				else 
					ns = s0;
					st = 0;
					{ug, uy, ur, mg, my, mr} = 6'b100001;				
			end
			s1: begin
				if ( ts ) 
					ns = s2;
					st = 1;
					{ug, uy, ur, mg, my, mr} = 6'b001100;				
				else 
					ns = s1;
					st = 0;
					{ug, uy, ur, mg, my, mr} = 6'b010001;
			end
			s2: begin
				if ( tl || ~c ) 
					ns = s3;
					st = 1;
					{ug, uy, ur, mg, my, mr} = 6'b001010;				
				else 
					ns = s2;
					st = 0;
					{ug, uy, ur, mg, my, mr} = 6'b001100;								
			end
			s3: begin
				if ( ts ) 
					ns = s0;
					st = 1;
					{ug, uy, ur, mg, my, mr} = 6'b100001;				
				else 
					ns = s3;
					st = 0;
					{ug, uy, ur, mg, my, mr} = 6'b001010;									
			end
			default: begin
			//initialization	
				st = 0;
				{ug, uy, ur, mg, my, mr} = 6'b100001;
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