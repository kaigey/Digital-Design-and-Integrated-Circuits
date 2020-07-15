//Using a combination always block, specify in Verilog a N-bit wide 4-to-1 multiplexor generator.
//Provide a circuit diagram, Verilog code, test bench, and test results.

module mux32four(d0, d1, d2， d3, sel, out);
	parameter N = 32;
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
			default: out = 32'b0;
		endcase
	end
	
endmodule


// Testbench
module test;

//toggling input is type logic
  logic i0;
  logic i1;
  logic i2;
  logic i3;
  logic sel;
 //output is type wire
  wire out;
  
  // Instantiate design under test
  decoder D0(.x0(i0), .x1(i1), .x2(i2), .x3(i3), .sel(sel), 
			.out(out));
          
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    i0 = 32'ha;
	i1 = 32'hb;
	i2 = 32'hc;
    i3 = 32'hd;
    $display("case 00");
	sel = 00;
    display;
    
    $display("case 01");
	sel = 01;
    display;
	
    $display("case 10");
	sel = 10;
    display;
	
    $display("case 11");
	sel = 11;
    display;

  end


  task display;
    #1 $display("out:%0h",
      out);
  endtask

endmodule