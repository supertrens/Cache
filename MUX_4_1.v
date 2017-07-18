

module MUX_4_1 (	in0,
			 		in1,
			 		in2,
			 		in3,
			 		sec,
			 		out);
	
	parameter bit_size = 18;

	input 	[bit_size-1:0]	in0, in1, in2, in3;
	input 	[1:0]			sec;
	output	[bit_size-1:0]	out;
	reg		[bit_size-1:0]	out;

	always @(*)
		out = sec[1] ? (sec[0] ? in3 : in2) : sec[0] ? in1 : in0;

endmodule
