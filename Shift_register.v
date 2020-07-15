//Design a simple 4-bit wide shift register with 3 registers, input sequence is 4’ha, 4’hb, 4’hc, 4’hd.
//Draw the expected waveform. Provide a circuit diagram, Verilog code, test bench, and test results.
//Note: when using registers in your Verilog, you will need to use the register library in EECS151.v

module shiftregister(out, data);
	input [3:0]data;
	output logic [3:0]out;
	
	logic [3:0]	shift1, shift2;
	
	DFF #(.N(4)) state (.q(shift1), .d(data), .clk(clock), .rst(reset));
	DFF #(.N(4)) state (.q(shift2), .d(shift1), .clk(clock), .rst(reset));
	DFF #(.N(4)) state (.q(out), .d(shift2), .clk(clock), .rst(reset));
	
endmodule

module DFF(q, d, clk, rst);
// register is N bit wide
// on the rising clock edge if rst is 1 then the state is set to the value of INIT. Default INIT value is all 0s.

	parameter N = 1;
	parameter INIT = 1'b0;
	
	input d, clk, rst;
	output logic q;
	
	always @(posedge clk)
		if (rst)
			q <= 1'b0;
		else
			q <= d;
endmodule

// Testbench
module test;

  logic  [3:0]data, clock, reset;
  wire [3:0]out;
  
  // Instantiate device under test
  shiftregister SR(.clock(clock),
          .data(data),
          .reset(reset),
          .out(out));
  
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1, test);

//	intialization
    clk = 0;
	reset = 1;
    data = 4’ha;
    $display("Initial out: %0h",
      out);
    
// first sample
	reset = 0;
    toggle_clk;
    $display("Out: %0h",
      out);

//	latch
    data = 4’hb;
    toggle_clk;
    $display("Out: %0h",
      out);
	  
//	sample
    toggle_clk;
    $display("Out: %0h",
      out);

//	latch
    data = 4’hc;
    toggle_clk;
    $display("Out: %0h",
      out);

//	sample
    toggle_clk;
    $display("Out: %0h",
      out);

//	latch
    data = 4’hd;
    toggle_clk;
    $display("Out: %0h",
      out);	  
	  
//	sample
    toggle_clk;
    $display("Out: %0h",
      out);
  end
  
  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
  
endmodule