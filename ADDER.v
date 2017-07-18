

module ADDER (	in1,
			 	in2,
			 	out);
	
	parameter bit_in = 18;
	parameter bit_out = 18;

	input [bit_in-1:0]	in1, in2;
	output [bit_out-1:0]	out;

	assign out = in1 + in2;

endmodule
