// MUX_2_1

module MUX_2_1 (	in0,
			 		in1,
			 		sec,
			 		out);
	
	parameter bit_size = 18;

	input	[bit_size-1:0]	in0, in1;
	input 					sec;
	output	[bit_size-1:0]	out;
	reg	[bit_size-1:0]	out;

	always@(*) 
		out = sec ? in1 : in0;

endmodule
