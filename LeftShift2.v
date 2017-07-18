// LeftShift2

module LeftShift2(	in,
					out);

	parameter bit_in = 16;

	input	[bit_in-1:0]	in;
	output	[bit_in+1:0]	out;

	assign out[bit_in+1:0] = {in[bit_in-1:0], 2'b00};

endmodule