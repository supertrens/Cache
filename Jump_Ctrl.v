// Jump_Ctrl

module Jump_Ctrl( Zero,
                  JumpOp,
				  // write your code in here
				  jump_pre_Op
				  );

    input 		Zero;
	output [1:0] JumpOp;

	// write your code in here
	input [1:0] jump_pre_Op;
	reg		[1:0] JumpOp;

	always@(*)
		if(jump_pre_Op == 2 && ~Zero)
			JumpOp = 0;
		else
			JumpOp = jump_pre_Op;
	
endmodule





