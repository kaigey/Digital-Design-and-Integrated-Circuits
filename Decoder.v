//Consider the decoder description written in a fake HDL presented in lecture 3, page 5 of the notes.
//Rewrite the "structural" version in Verilog using continuous assignment statements. Provide a
//circuit diagram, Verilog code, test bench, and test results

module decoder(x0, x1, x2, x3, a, b);
	input a, b;
	output x0, x1, x2, x3;

	assign x0 = ~a && ~b;
	assign x1 = ~a && b;
	assign x2 = a && ~b;
	assign x3 = a && b;
	
endmodule

// Testbench
module test;

//toggling input is type logic
//output is type wire
  wire x0;
  wire x1;
  wire x2;
  wire x3;
  logic a;
  logic b;
  
  // Instantiate design under test
  decoder D0(.x0(x0), .x1(x1), .x2(x2), .x3(x3),
          .a(a), .b(b));
          
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    $display("case 00");
    a = 0;
    b = 0;
    display;
    
    $display("case 01");
    a = 0;
    b = 1;
    display;
	
    $display("case 10");
    a = 1;
    b = 0;
    display;
	
    $display("case 11");
    a = 1;
    b = 1;
    display;

  end


  task display;
    #1 $display("x0 = %b, x1 = %b, x2 = %b, x3 = %b",
      x0, x1, x2, x3);
  endtask

endmodule