// SignExtend

module SignExtend(	in,
					out);

	parameter bit_in = 16;
	parameter bit_out = 32;

	input	[bit_in-1:0]	in;
	output	[bit_out-1:0]	out;

	assign out[bit_out-1:0] = {{(bit_out - bit_in){in[bit_in-1]}},in[bit_in-1:0]};

endmodule